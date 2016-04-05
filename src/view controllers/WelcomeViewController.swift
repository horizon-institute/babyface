//
//  RootViewController.swift
//  babyface
//
//  Created by Kevin Glover on 27/03/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//
import UIKit

class WelcomeViewController: UIViewController
{
	@IBOutlet weak var startButton: UIButton!
	init()
	{
		super.init(nibName: "WelcomeView", bundle: nil)
	}
	
	required init?(coder: NSCoder)
	{
		super.init(coder: coder)
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		startButton.hidden = false
	}

	@IBAction func start()
	{
		navigationController?.pushViewController(RootViewController(), animated: true)
	}
}