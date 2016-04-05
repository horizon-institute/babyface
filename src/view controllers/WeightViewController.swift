//
//  DataViewController.swift
//  babyface
//
//  Created by Kevin Glover on 16/04/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import Foundation
import UIKit

class WeightViewController: PageViewController, UIPickerViewDataSource, UIPickerViewDelegate
{
	@IBOutlet weak var weightPicker: UIPickerView!
	@IBOutlet weak var formatSelect: UISegmentedControl!
	
	init()
	{
		super.init(param: "weight", nib:"WeightView")
	}

	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		update(self)
	}
	
	override func viewWillAppear(animated: Bool)
	{
		update(self)
	}
	
	override func viewWillDisappear(animated: Bool)
	{
	}

	func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
	{
		return 1
	}
	
	func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
	{
		if formatSelect.selectedSegmentIndex == 0
		{
			return 41
		}
		else
		{
			return 122 - 35 + 1
		}
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
		
		if formatSelect.selectedSegmentIndex == 0
		{

			let value = Double(16 - 1 + row) / 10.0
			return "\(value)kg"
		}
		else
		{
			let value = Double(35 - 1 + row) / 10.0
			return "\(value)lb"
		}
	}	
	
	@IBAction func update(sender: AnyObject)
	{
		weightPicker.reloadAllComponents()
	}
}