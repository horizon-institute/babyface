//
//  DataModel.swift
//  babyface
//
//  Created by Kevin Glover on 15/04/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import Foundation

class BabyData
{
	var images = [String: NSData]()
	var gender : String?
	var ethnicity : String?
	var weight: Float = 0.0
	var age = 0
	var due = 0
	var country: String = ""
}