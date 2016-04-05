//
//  CameraOutputViewController.swift
//  babyface
//
//  Created by Kevin Glover on 15/04/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import Foundation
import UIKit

class CameraResultViewController: PageViewController
{
	@IBOutlet weak var resultImage: UIImageView!
	@IBOutlet weak var resultLabel: UILabel!
	
	override init(param: String)
	{
		super.init(param: param, nib: "CameraResultView")
	}

	required init?(coder aDecoder: NSCoder)
	{
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		resultLabel.text = NSLocalizedString(paramName + "_result", comment: paramName)
		
		if let imageData = pageController?.parameters[paramName] as? NSData
		{
			resultImage.image = UIImage(data: imageData)
			view.layoutIfNeeded()
			resultImage.layoutIfNeeded()
		}
	}
}