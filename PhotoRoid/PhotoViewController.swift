//
//  ViewController.swift
//  PhotoRoid
//
//  Created by kenjimaeda on 12/09/22.
//

import UIKit

class PhotoViewController: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.setNavigationBarHidden(true, animated: true)
	}
	
	@IBAction func handleImage(_ sender: UIButton) {
		let alert = UIAlertController(title: "Chosse your photo", message: "Select where would you like to take this photo ", preferredStyle: .actionSheet)
		
		if UIImagePickerController.isSourceTypeAvailable(.camera) {
			let camera = UIAlertAction(title: "Camera", style: .default) { [self](action) in
				optionSelected(.camera)
			}
			alert.addAction(camera)
		}
		
		let libraryPhoto = UIAlertAction(title: "Library photo", style: .default) {[self](action) in
			optionSelected(.photoLibrary)
		}
		alert.addAction(libraryPhoto)
		let galleryPhoto = UIAlertAction(title: "Gallery photo", style: .default) {[self](action) in
			optionSelected(.savedPhotosAlbum)
		}
		alert.addAction(galleryPhoto)
		
		let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
		alert.addAction(cancel)
		
		present(alert, animated: true)
		
	}
	
	func  optionSelected(_ sourceType: UIImagePickerController.SourceType) {
		  let imageController = UIImagePickerController()
		imageController.sourceType = sourceType
		imageController.delegate = self
		present(imageController, animated: true)
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if  segue.identifier == "effectsSegue" {
			let vc = segue.destination as! EffectsViewController
			vc.image = sender as? UIImage
		}
	}
	
}

//MARK: - UIImagePickerControllerDelegate,UINavigationControllerDelegate
extension PhotoViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		if	let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
			let width = image.size.width
			let aspectRatio =  width / image.size.height
			var smallSize: CGSize
			//se aspectRatio > 1 e landscape,porque a largura e maior
			if aspectRatio > 1 {
				 smallSize = CGSize(width: 1000, height: 1000/aspectRatio)
			}else {
				smallSize = CGSize(width: 1000 * aspectRatio, height: 1000)
			}
		  
			//redesenhar a imagem,contexto e uma area salva para desenhos
			UIGraphicsBeginImageContext(smallSize)
			image.draw(in: CGRect(x: 0, y: 0, width: smallSize.width, height: smallSize.height))
			let imageSmall = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			//
			
			dismiss(animated: true) {
				self.performSegue(withIdentifier: "effectsSegue", sender: imageSmall)
			}
			
			
		}
	}
}
