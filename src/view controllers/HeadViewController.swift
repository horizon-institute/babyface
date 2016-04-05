//
//  DataViewController.swift
//  babyface
//
//  Created by Kevin Glover on 16/04/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import Foundation
import UIKit

class HeadViewController: PageViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
	@IBOutlet weak var weightPicker: UIPickerView!
	
	init()
	{
		super.init(param: "headCircumference", nib:"HeadView")
	}

	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
	{
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
	{
		return 121
	}
	
	func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
	{
		pageController?.parameters[paramName] = self.pickerView(pickerView, titleForRow: row, forComponent: component)
	}
	
	func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
	{
		if row == 0
		{
			return "Unknown"
		}
		
		let value = Double(300 - 1 + row) / 10.0
		return "\(value)cm"
	}
}