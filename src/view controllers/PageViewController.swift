import UIKit

class PageViewController: UIViewController
{
	let paramName: String
	var pageController: RootViewController?
	
	init(param: String)
	{
		paramName = param
		super.init(nibName: paramName.capitalizedString + "View", bundle: nil)
	}
	
	init(param: String, nib: String)
	{
		paramName = param
		super.init(nibName: nib, bundle: nil)
	}
	
	init(nib: String)
	{
		paramName = ""
		super.init(nibName: nib, bundle: nil)
	}

	required init?(coder aDecoder: NSCoder)
	{
		paramName = ""
		super.init(coder: aDecoder)
	}

	var prevPage: Bool
	{
		return true
	}
	
	var nextPage: Bool
	{
		return true
	}

	var trim: Bool
	{
		return true
	}
	
	@IBAction func openPolicy(sender: AnyObject)
	{
		if let url = NSURL(string:"http://cvl.cs.nott.ac.uk/resources/babyface/pages/app.html#privacy")
		{
			UIApplication.sharedApplication().openURL(url)
		}
	}
	
	override func viewDidAppear(animated: Bool)
	{
		
	}
}