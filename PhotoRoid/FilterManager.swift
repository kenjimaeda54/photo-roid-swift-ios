//
//  FilterManager.swift
//  PhotoRoid
//
//  Created by kenjimaeda on 13/09/22.
//

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
	
	//aqui vai colocar o rawValeu,porque colocamos que nosso enum e do tipo Int
	func applyFilter(_ type: FilterType) -> UIImage {
		let ciImage = CIImage(image: originalImage)
		//rawValue o indicie do enum
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
