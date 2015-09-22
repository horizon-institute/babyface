//
//  CameraOutputViewController.swift
//  babyface
//
//  Created by Kevin Glover on 15/04/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import Foundation
import UIKit

class CameraOutputViewController: PageViewController
{
	@IBOutlet weak var outputImage: UIImageView!

	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		let imageData = pageController?.babyData.images[photoName]
		if imageData != nil
		{
			outputImage.image = UIImage(data: imageData!)
			view.layoutIfNeeded()
			outputImage.layoutIfNeeded()
		}
	}
	
	var photoName: String
	{
		let endIndex = restorationIdentifier!.startIndex.advancedBy(3)
		return restorationIdentifier!.substringToIndex(endIndex)
	}
}