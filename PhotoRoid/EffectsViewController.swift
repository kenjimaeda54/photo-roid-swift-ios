//
//  EffectsViewController.swift
//  PhotoRoid
//
//  Created by kenjimaeda on 12/09/22.
//

import UIKit

class EffectsViewController: UIViewController {
	
	var image: UIImage!
	
	//para loading o ideal e usar uma view no fundo
	//manipular a view nao o activIndicator
	@IBOutlet weak var viLoading: UIView!
	@IBOutlet weak var imgPhoto: UIImageView!
	@IBOutlet weak var collectionPhoto: UICollectionView!

	
	//lazy e importante para primeiro a classe ser criada depois a variavel
	//ser instanciada
	lazy	var filterManager = FilterManager(originalImage: image)
	var filteredImageNames = [
		"comic",
		"sepia",
		"halftone",
		"crystallize",
		"vignette",
		"noir"
	]
	
	
	override func viewDidLoad() {
		super.viewDidLoad()
		collectionPhoto.delegate = self
		collectionPhoto.dataSource = self
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.setNavigationBarHidden(false, animated: true)
		imgPhoto.image = image
	}
	
	func isLoading(_ show: Bool) {
		viLoading.isHidden = !show
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "finishSegue"{
			let vc = segue.destination as! FinishViewController
			vc.image = imgPhoto.image
		}
	}
	
}


//MARK: - UICollectionViewDelegate,UICollectionViewDataSource
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
			//vou aplicar uma nova thread devido ao load em parelo ao filtro
			//tambem e ideal quando estamos realizando requisicoes na internet
			
			//com dispatchQueue eu inicio uma nova thread
			//toda thread que manipula aspecto visual precisa ser na main
			//entao apos terminar codigo na global tenho que voltar
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

