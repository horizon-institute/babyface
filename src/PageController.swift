//
//  ModelController.swift
//  babyface
//
//  Created by Kevin Glover on 27/03/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//
import UIKit

class PageController: NSObject, UIPageViewControllerDataSource
{
	let pageViewController = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
	let babyData = BabyData()
	let pageNames = ["WelcomeViewController", "AboutViewController", "PrivacyPolicyViewController", "DataViewController", "FaceCameraViewController", "FaceOutputViewController", "EarCameraViewController", "EarOutputViewController", "FootCameraViewController", "FootOutputViewController" ]
	
	var count: Int
	{
		return pageNames.count;
	}

	override init()
	{
	    super.init()
		
		pageViewController.dataSource = self
	}

	func prevPage(viewController: UIViewController)
	{
		let prevController = pageViewController(pageViewController, viewControllerBeforeViewController: viewController)
		if prevController != nil
		{
			let viewControllers: [UIViewController] = [prevController!]
			pageViewController.setViewControllers(viewControllers, direction:.Reverse, animated: true, completion: nil)
		}
	}
	
	func nextPage(viewController: UIViewController)
	{
		let nextController = pageViewController(pageViewController, viewControllerAfterViewController: viewController)
		if nextController != nil
		{
			let viewControllers: [UIViewController] = [nextController!]
			pageViewController.setViewControllers(viewControllers, direction:.Forward, animated: true, completion: nil)
		}
	}
	
	func refresh(viewController: UIViewController)
	{
		let viewControllers: [UIViewController] = [viewController]
		pageViewController.setViewControllers(viewControllers, direction:.Forward, animated: false, completion: nil)
	}
	
	func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController?
	{
		if (pageNames.count == 0) || (index >= pageNames.count)
		{
		    return nil
		}

		let viewController = storyboard.instantiateViewControllerWithIdentifier(pageNames[index]) as? UIViewController
		if let pageViewController = viewController as? PageViewController
		{
			pageViewController.pageController = self;
		}
		
		return viewController;
	}

	func indexOfViewController(viewController: UIViewController) -> Int
	{
		var index = 0
		for page in pageNames
		{
			if page == viewController.restorationIdentifier
			{
				return index;
			}
			index++
		}
	    return NSNotFound
	}
	
	// MARK: - Page View Controller Data Source
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
	{
	    var index = indexOfViewController(viewController)
	    if (index == 0) || (index == NSNotFound)
		{
	        return nil
	    }
	    
	    index--
	    return viewControllerAtIndex(index, storyboard: viewController.storyboard!)
	}

	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
	{
		let pageController = viewController as? PageViewController
		if pageController != nil && !pageController!.nextPage
		{
			return nil
		}
	    var index = indexOfViewController(viewController)
	    if index == NSNotFound
		{
	        return nil
	    }
	    
	    index++
	    if index >= pageNames.count
		{
	        return nil
	    }
	    return viewControllerAtIndex(index, storyboard: viewController.storyboard!)
	}
}