//
//  EffectsViewController.swift
//  PhotoRoid
//
//  Created by kenjimaeda on 12/09/22.
//

import UIKit

class EffectsViewController: UIViewController {
	
	var image: UIImage!
	
	@IBOutlet weak var imgPhoto: UIImageView!
	@IBOutlet weak var collectionPhoto: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imgPhoto.image = image
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(true)
		navigationController?.setNavigationBarHidden(false, animated: true)
	}
	
	

	
}
