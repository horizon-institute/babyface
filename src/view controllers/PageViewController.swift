//
//  PageViewController.swift
//  babyface
//
//  Created by Kevin Glover on 30/03/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import UIKit

class PageViewController: UIViewController
{
	var pageController: PageController?
	
	var nextPage: Bool
	{
		return true
	}

	@IBAction func prevPage(sender: AnyObject)
	{
		pageController?.prevPage(self)
	}
	
	@IBAction func nextPage(sender: AnyObject)
	{
		pageController?.nextPage(self)
	}
	
	@IBAction func date(sender: AnyObject)
	{
		let currentDate = NSDate()
		let dateComponents = NSDateComponents()
		dateComponents.day = -7
		dateComponents.month = -9
		let date = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: currentDate, options: NSCalendarOptions(0))
		// http://numbersapi.com/\(month)/\(day)/date
		// Stupid americans
		
	}
	
	@IBAction func privacyPolicy(sender: AnyObject)
	{
		if let url = NSURL(string:"http://cvl.cs.nott.ac.uk/resources/babyface/pages/app.html#privacy")
		{
			UIApplication.sharedApplication().openURL(url)
		}
	}
}