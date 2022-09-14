# Photo Roid
Aplicativo para aplicar filtros em fotos e salvar

##Motivação
Aprende como pegar foto, aplicar filtros e salvar no device

## Feature
- Para manipular as fotos usamos os delegate UIImagePickerControllerDelegate,UINavigationControllerDelegate
- No método didFinishPickingMediaWithInfo conseguimos saber exato  momento que foto foi selecionado 
- Para evitar fotos grandes redesenhei as imagens no contexto 
- Contexto e uma área destinada a gráficos, desenhos e imagens
- Para identificar-se a foto està em landscape or portrait utilitzei o aspectRatio


```swift

extension PhotoViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		let originalImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
		let width = originalImage.size.width
		let aspectRatio = width / originalImage.size.height
		let smallSize: CGSize
		
		//se aspectRatio > 1 e landscape,porque a largura e maior
		if aspectRatio > 1 {
			smallSize = CGSize(width: 1000, height: 1000/aspectRatio)
		}else {
			smallSize  = CGSize(width: 1000 * aspectRatio, height: 1000)
		}
		

		UIGraphicsBeginImageContext(smallSize)
		originalImage.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
		let smallImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
	
		
		dismiss(animated: true) {
			self.performSegue(withIdentifier: "effectsSegue", sender: smallImage)
		}
		
	}
}

```

## 

- Eu consigo criar um enum e percorrer pelos seus índices usando rawValue
- Abaixo criei um enum de efeitos do tipo int, assim consigo aplicar os efeitos baseados no índice
- As ordens do enum precisam ser idêntica ao filterNames


```swift

import UIKit

enum  FilterType: Int {
	case comic
	case sepia
	case halftone
	case crystallize
	case vignette
	case noir
}


struct FilterManager {
	
	var originalImage: UIImage
	var context = CIContext(options: nil)
	var filterNames = [
		"CIComicEffect",
		"CISepiaTone",
		"CICMYKHalftone",
		"CICrystallize",
		"CIVignette",
		"CIPhotoEffectNoir"
		
	]
	
	
	func applyFilter(_ type: FilterType) -> UIImage {
		let ciImage = CIImage(image: originalImage)
		let filter = CIFilter(name: filterNames[type.rawValue])
		filter?.setValue(ciImage, forKey: kCIInputImageKey)
		
		switch type {
		case .comic:
			break
		case .sepia:
			filter?.setValue(1.0, forKey: kCIInputIntensityKey)
		case .halftone:
			filter?.setValue(25, forKey: kCIInputWidthKey)
		case .crystallize:
			filter?.setValue(25, forKey: kCIInputRadiusKey)
		case .vignette:
			filter?.setValue(3, forKey: kCIInputIntensityKey)
			filter?.setValue(30, forKey: kCIInputRadiusKey)
		case .noir:
			break
		}
		
		let filteredImage = filter?.value(forKey: kCIOutputImageKey) as! CIImage
		//from: e o tamanho da imagem
		let contextImage = context.createCGImage(filteredImage, from: filteredImage.extent)
		
		return UIImage(cgImage: contextImage!)
		
	}
	
	
}

```

##
- Aprendi utilizar outras thread com DispatchQueue
- Thread principal e a main, todo desenho em uma interface fica na main
- Caso esteja em outra thread precisa retornar a principal
- Aprendi o uso de collectionView, mesma ideia do tableView
- Ele também implementa um delegate e um dataSource
- Para ser executado um filtro custa tempo, então coloquei  forma paralela outra thread, assim usuário consegue visualizar o loading



```swift

extension EffectsViewController: UICollectionViewDelegate, UICollectionViewDataSource{
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return filterManager.filterNames.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EffectsCollectionViewCell
		cell.imageCollection.image = UIImage(named: filteredImageNames[indexPath.row])
		return cell
	}
	
	//itens selecionado
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		self.isLoading(true)
		if let filterSelected = FilterType(rawValue: indexPath.row) {
			
			DispatchQueue.global(qos: .userInitiated).async {
				let imageFiltered = self.filterManager.applyFilter(filterSelected)
				
				//main e a principal aonde ocorre toda manipulacao de interfaces,elementos da tela
				DispatchQueue.main.async {
					self.imgPhoto.image = imageFiltered
					self.isLoading(false)
				}
				
			}
			
		}
	}
	
}

```

## 
- Para salvar fotos usamos framework Photo
- Preciso garantir que usuário permitiu o acesso à galeria de fotos
- Apos isto crio uma requisição com a imagem que desejo salvar
- performChanges ocorre em outra thread então retornei a main


```swift

func savePhoto ()  {
	
		PHPhotoLibrary.shared().performChanges({
			let createRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
			let addImageRequest = PHAssetCollectionChangeRequest()
			addImageRequest.addAssets([createRequest.placeholderForCreatedAsset] as! NSArray)

		}){(sucess,error) in
			
			if sucess {
				DispatchQueue.main.async {
					self.alert(message: "Your photo save with sucess", title: "Save")
				}
				return
			}
			print(error?.localizedDescription)
		}
		
	}
	
	@IBAction func handleSavePhoto(_ sender: UIButton) {
		PHPhotoLibrary.requestAuthorization {[self](status) in
			switch status {
			case .authorized:
				savePhoto()
			default:
				alert(message: "To save we need to access your photo gallery", title: "Error")
			}
		}
		
	}
	
	
	@IBAction func handleStartAgain(_ sender: UIButton) {
		navigationController?.popToRootViewController(animated: true)
	}

```













