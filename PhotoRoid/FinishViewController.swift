//
//  FinishViewController.swift
//  PhotoRoid
//
//  Created by kenjimaeda on 12/09/22.
//

import UIKit
import Photos

class FinishViewController: UIViewController {
	
	@IBOutlet weak var imgPhoto: UIImageView!
	var image: UIImage!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imgPhoto.image = image
		imgPhoto.layer.borderWidth = 10
		imgPhoto.layer.borderColor = UIColor.white.cgColor
	}
	
	
	func alert(message: String,title: String) {
		let alert = UIAlertController(title:title, message: message, preferredStyle: .alert)
		let isOk = UIAlertAction(title: "OK", style: .cancel)
		alert.addAction(isOk)
		present(alert, animated: true)
	}
	
	func savePhoto ()  {
		//performChanges esta ocorrendo em uma thread separa poor isso
		//alerta foi jogado na main
		PHPhotoLibrary.shared().performChanges({
			let createRequest = PHAssetChangeRequest.creationRequestForAsset(from: self.image)
			let addRequestImg = PHAssetCollectionChangeRequest()
			addRequestImg.addAssets([createRequest.placeholderForCreatedAsset] as! NSArray)
			
		}){[self](sucess,error) in
			if sucess {
				DispatchQueue.main.async {
					self.alert(message: "Congralations your photo has been saved", title: "Sucess")
				}
				return
			}
			print(error?.localizedDescription)
		}
		
	}
	
	@IBAction func handleSavePhoto(_ sender: UIButton) {
		PHPhotoLibrary.requestAuthorization {[self] (status) in
			switch status {
			case .authorized:
				savePhoto()
			default:
				alert(message: "To save we need to access your photo gallery", title: "Error")
			}
			
		}
		
	}
	
	
	@IBAction func handleStartAgain(_ sender: UIButton) {
	}
}
