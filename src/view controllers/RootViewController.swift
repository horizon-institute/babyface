//
//  RootViewController.swift
//  babyface
//
//  Created by Kevin Glover on 27/03/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//
import UIKit

class RootViewController: UIPageViewController, UIPageViewControllerDataSource
{
    let babyData = BabyData()
    var pageNames: [String]
    {
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad
        {
            return ["WelcomeViewController", "PrivacyPolicyViewController", "DataViewController", "FaceCameraViewController", "FaceOutputViewController", "EarCameraViewController", "EarOutputViewController", "FootCameraViewController", "FootOutputViewController" ]
        }
        return ["WelcomeViewController", "AboutViewController", "PrivacyPolicyViewController", "DataViewController", "FaceCameraViewController", "FaceOutputViewController", "EarCameraViewController", "EarOutputViewController", "FootCameraViewController", "FootOutputViewController" ]
    }
    
    var count: Int
    {
         return pageNames.count
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        dataSource = self
        
        let startingViewController: UIViewController = viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil)
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
            setViewControllers(viewControllers, direction:.Reverse, animated: true, completion: nil)
        }
    }
    
    func nextPage(viewController: UIViewController)
    {
        let nextController = pageViewController(self, viewControllerAfterViewController: viewController)
        if nextController != nil
        {
            let viewControllers: [UIViewController] = [nextController!]
            setViewControllers(viewControllers, direction:.Forward, animated: true, completion: nil)
        }
    }
    
    func refresh(viewController: UIViewController)
    {
        let viewControllers: [UIViewController] = [viewController]
        setViewControllers(viewControllers, direction:.Forward, animated: false, completion: nil)
    }
    
    func viewControllerAtIndex(index: Int, storyboard: UIStoryboard) -> UIViewController?
    {
        if (pageNames.count == 0) || (index >= pageNames.count)
        {
            return nil
        }
        
        let viewController = storyboard.instantiateViewControllerWithIdentifier(pageNames[index]) as UIViewController
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