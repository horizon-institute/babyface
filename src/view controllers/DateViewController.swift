//
//  DataViewController.swift
//  babyface
//
//  Created by Kevin Glover on 16/04/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import Foundation
import UIKit

class DateViewController: PageViewController
{
	@IBOutlet weak var datePicker: UIDatePicker!
	@IBOutlet weak var label: UILabel!
	
	let calendar = NSCalendar.currentCalendar()
	let dateFormatter = NSDateFormatter()
	
	override init(param: String)
	{
		super.init(param: param, nib:"DateView")
	}

	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		label.text = NSLocalizedString(paramName, comment: paramName)
		
		dateFormatter.dateStyle = .MediumStyle
		dateFormatter.timeStyle = .NoStyle

		let minComponents = NSDateComponents()
		minComponents.month = -6
		datePicker.minimumDate = calendar.dateByAddingComponents(minComponents, toDate: NSDate(), options: [])
		if paramName == "birthDate"
		{
			datePicker.maximumDate = NSDate()
		}
		else
		{
			let components = NSDateComponents()
			components.month = 1

			datePicker.maximumDate = calendar.dateByAddingComponents(components, toDate: NSDate(), options: [])
		}
	}
	
	override func viewWillAppear(animated: Bool)
	{
		if let dateString = pageController?.parameters[paramName] as? String
		{
			if let date = dateFormatter.dateFromString(dateString)
			{
				datePicker.date = date
			}
		}
	}

	override func viewWillDisappear(animated: Bool)
	{
		pageController?.parameters[paramName] = dateFormatter.stringFromDate(datePicker.date)
		
		if paramName == "birthDate"
		{
			let today = NSDate()
			
			let components = calendar.components(.Day, fromDate: datePicker.date, toDate: today, options: [])
			pageController?.parameters["age"] = "\(components.day) days"
		}
		
	}
}