//
//  RootViewController.swift
//  babyface
//
//  Created by Kevin Glover on 27/03/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//
import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate
{
	var pageController = PageController()
	
	override func viewDidLoad()
	{
		super.viewDidLoad()

		let startingViewController: UIViewController = pageController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
		let viewControllers = [startingViewController]
		pageController.pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
		pageController.pageViewController.delegate = self

		addChildViewController(pageController.pageViewController)
		view.addSubview(pageController.pageViewController.view)

		// Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
		var pageViewRect = view.bounds
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad
		{
		    pageViewRect = CGRectInset(pageViewRect, 40.0, 40.0)
		}
		pageController.pageViewController.view.frame = view.bounds
		pageController.pageViewController.didMoveToParentViewController(self)

		// Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
		view.gestureRecognizers = pageController.pageViewController.gestureRecognizers
	}
	
	override func didReceiveMemoryWarning()
	{
		super.didReceiveMemoryWarning()
	}

	// MARK: - UIPageViewController delegate methods

	func pageViewController(pageViewController: UIPageViewController, spineLocationForInterfaceOrientation orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation
	{
	    let currentViewController = pageViewController.viewControllers[0] as! UIViewController
	    let viewControllers = [currentViewController]
	    pageViewController.setViewControllers(viewControllers, direction: .Forward, animated: true, completion: {done in })
	    pageViewController.doubleSided = false
	    return .Min
	}
	
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool)
	{
	}
}