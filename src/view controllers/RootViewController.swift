//
//  RootViewController.swift
//  babyface
//
//  Created by Kevin Glover on 27/03/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//
import UIKit

class RootViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
	var parameters: [String: AnyObject] = ["version":NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"]!]
	let vcs: [PageViewController] = [
		PageViewController(nib: "AboutView"),
		PageViewController(nib: "PolicyView"),
		CheckViewController(param: "gender"),
		CheckViewController(param: "ethnicity"),
		WeightViewController(),
		HeadViewController(),
		DateViewController(param: "birthDate"),
		DateViewController(param: "expectedDate"),
		CheckViewController(param: "expectedBasis"),
		PageViewController(nib: "PhotoIntroView"),
		CameraViewController(param: "face"),
		CameraResultViewController(param: "face"),
		CameraViewController(param: "ear"),
		CameraResultViewController(param: "ear"),
		CameraViewController(param: "foot"),
		CameraResultViewController(param: "foot"),
		UploadViewController()
	]
	
	let header = UIView()
	
	var nextButton: UIBarButtonItem!
	var prevButton: UIBarButtonItem!
	
	init()
	{
		super.init(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: [:])
	}
	
	required init?(coder: NSCoder)
	{
		super.init(coder: coder)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
		//dataSource = self
		delegate = self
		
		
		header.translatesAutoresizingMaskIntoConstraints = false
		view.insertSubview(header, atIndex: 0)
		view.backgroundColor = UIColor.whiteColor()
		
		header.clipsToBounds = false
		header.layer.shadowColor = UIColor.blackColor().CGColor
		header.layer.shadowOffset = CGSizeMake(0, 1)
		header.layer.shadowOpacity = 0.4
		header.layer.shadowRadius = 2

		let headerImage = UIImageView(image: UIImage(named: "header.jpg"))
		headerImage.translatesAutoresizingMaskIntoConstraints = false
		headerImage.contentMode = .ScaleAspectFill
		headerImage.clipsToBounds = true
		
		header.addSubview(headerImage)
		
		header.addConstraint(NSLayoutConstraint(item: headerImage, attribute: .Top, relatedBy: .Equal, toItem: header, attribute: .Top, multiplier: 1, constant: 0))
		header.addConstraint(NSLayoutConstraint(item: headerImage, attribute: .Bottom, relatedBy: .Equal, toItem: header, attribute: .Bottom, multiplier: 1, constant: 0))
		header.addConstraint(NSLayoutConstraint(item: headerImage, attribute: .Left, relatedBy: .Equal, toItem: header, attribute: .Left, multiplier: 1, constant: 0))
		header.addConstraint(NSLayoutConstraint(item: headerImage, attribute: .Right, relatedBy: .Equal, toItem: header, attribute: .Right, multiplier: 1, constant: 0))
		
		view.addConstraint(NSLayoutConstraint(item: header, attribute: .Top, relatedBy: .Equal, toItem: view, attribute: .Top, multiplier: 1, constant: 0))
		view.addConstraint(NSLayoutConstraint(item: header, attribute: .Left, relatedBy: .Equal, toItem: view, attribute: .Left, multiplier: 1, constant: 0))
		view.addConstraint(NSLayoutConstraint(item: header, attribute: .Right, relatedBy: .Equal, toItem: view, attribute: .Right, multiplier: 1, constant: 0))
		view.addConstraint(NSLayoutConstraint(item: header, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 145))
		view.layoutIfNeeded()
		NSLog("\(header.bounds)")
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		setViewControllers([vcs[0]], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
		
		prevButton = UIBarButtonItem(image: UIImage(named: "ic_chevron_left"), style: .Plain, target: self, action: #selector(RootViewController.prev))
		prevButton.tintColor = UIColor.blackColor()
		
		let button = UIButton()
		button.setImage(UIImage(named: "ic_chevron_right"), forState: .Normal)
		button.setTitle("NEXT", forState: .Normal)
		button.setTitleColor(UIColor.blackColor(), forState: .Normal)
		button.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
		button.tintColor = UIColor.blackColor()
		button.transform = CGAffineTransformMakeScale(-1.0, 1.0)
		button.imageView?.transform = CGAffineTransformMakeScale(-1.0, 1.0)
		button.titleLabel?.transform = CGAffineTransformMakeScale(-1.0, 1.0)
		button.sizeToFit()
		button.addTarget(self, action: #selector(RootViewController.next), forControlEvents: .TouchUpInside)
		nextButton = UIBarButtonItem(customView: button)
		
		setToolbarItems([
			prevButton,
			UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
			nextButton], animated: true)
		
		update()
	}

	func prev()
	{
		prevPage((viewControllers?.first)!)
	}	
	
	func next()
	{
		nextPage((viewControllers?.first)!)
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController?
	{
		var currentIndex = 0
		if let page = viewController as? PageViewController
		{
			if !page.nextPage
			{
				return nil
			}
			if let nibIndex = vcs.indexOf(page)
			{
				currentIndex = nibIndex
			}
		}
		
		if currentIndex == vcs.count - 1
		{
			return nil
		}
		
		let vc = vcs[currentIndex + 1]
		vc.pageController = self
		return vc
		
	}
	
	func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController?
	{
		var currentIndex = 0
		if let page = viewController as? PageViewController
		{
			if !page.prevPage
			{
				return nil
			}
			if let nibIndex = vcs.indexOf(page)
			{
				currentIndex = nibIndex
			}
		}
		
		if currentIndex == 0
		{
			return nil
		}
		
		let vc = vcs[currentIndex - 1]
		vc.pageController = self
		return vc
	}
	
	func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
	{
		update()
	}
	
	func update()
	{
		if let page = viewControllers?.first as? PageViewController
		{
			if let nibIndex = vcs.indexOf(page)
			{
				var items: [UIBarButtonItem] = []
				if (nibIndex != 0) && page.prevPage
				{
					items.append(prevButton)
				}
				items.append(UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil))
				if (nibIndex < vcs.count - 1) && page.nextPage
				{
					items.append(nextButton)
				}
				navigationController?.setToolbarHidden(!page.trim, animated: true)
				
				setToolbarItems(items, animated: true)
			}
		}
		nextButton.customView?.sizeToFit()
	}
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func prevPage(viewController: UIViewController)
    {
        let prevController = pageViewController(self, viewControllerBeforeViewController: viewController)
        if prevController != nil
        {
            let viewControllers: [UIViewController] = [prevController!]
			setViewControllers(viewControllers, direction:.Reverse, animated: true, completion:  { (completed) -> Void in
				self.update()
			})
        }
    }
    
    func nextPage(viewController: UIViewController)
    {
        let nextController = pageViewController(self, viewControllerAfterViewController: viewController)
        if nextController != nil
        {
            let viewControllers: [UIViewController] = [nextController!]
			setViewControllers(viewControllers, direction: .Forward, animated: true, completion: { (completed) -> Void in
				self.update()
			})
        }
    }
}