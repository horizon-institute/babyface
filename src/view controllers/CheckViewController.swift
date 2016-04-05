//
//  DataViewController.swift
//  babyface
//
//  Created by Kevin Glover on 16/04/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import Foundation
import UIKit

class CheckViewController: PageViewController
{
	override var nextPage: Bool
	{
		return pageController?.parameters[paramName] != nil
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		
		updateView(false)

	}

	func selected(value: String)
	{
		if !paramIs(value)
		{
			pageController?.parameters[paramName] = value
			updateView(true)
		}
	}
	
	func updateView(view: UIView, animated: Bool)
	{
		if let viewID = view.restorationIdentifier
		{
			for subview in view.subviews
			{
				if subview is UIImageView
				{
					if paramIs(viewID)
					{
						if animated
						{
							subview.circleReveal(0.2)
						}
						else
						{
							subview.hidden = false
						}
					}
					else if !subview.hidden
					{
						if animated
						{
							subview.circleHide(0.2)
						}
						else
						{
							subview.hidden = true
						}
					}
				}
			}
		}
		else
		{
			for subview in view.subviews
			{
				updateView(subview, animated: animated)
			}
		}
	}
	
	func updateView(animated: Bool)
	{
		updateView(view, animated: animated)
		pageController?.update()
	}

	func paramIs(value: String) -> Bool
	{
		if let param = pageController?.parameters[paramName] as? String
		{
			return param == value
		}
		return false
	}
	
	@IBAction func selectValue(sender: AnyObject)
	{
		if let view = sender as? UIView
		{
			if let value = view.restorationIdentifier
			{
				selected(value)
			}
		}
		else if let gesture = sender as? UIGestureRecognizer
		{
			if let view = gesture.view
			{
				if let value = view.restorationIdentifier
				{
					selected(value)
				}
			}
		}
	}
}