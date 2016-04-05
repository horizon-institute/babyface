//
//  Extensions.swift
//  babyface
//
//  Created by Kevin Glover on 15 Mar 2016.
//  Copyright © 2016 Horizon. All rights reserved.
//

import Foundation
import UIKit

extension UIView
{
	func makeCirclePath(bounds: CGRect) -> CGPathRef
	{
		return UIBezierPath(roundedRect: bounds, cornerRadius: bounds.width).CGPath
	}
	
	func circleReveal(speed: CFTimeInterval)
	{
		let mask = CAShapeLayer()
		mask.path = makeCirclePath(CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0))
		mask.fillColor = UIColor.blackColor().CGColor
		
		layer.mask = mask
		
		CATransaction.begin()
		let animation = CABasicAnimation(keyPath: "path")
		animation.duration = speed
		animation.fillMode = kCAFillModeForwards
		animation.removedOnCompletion = false
		
		let size = max(bounds.width, bounds.height)
		let newPath = makeCirclePath(CGRect(x: bounds.midX - (size / 2), y: bounds.midY - (size / 2), width: size, height: size))
		animation.fromValue = mask.path
		animation.toValue = newPath
		
		CATransaction.setCompletionBlock() {
			self.layer.mask = nil;
		}
		
		mask.addAnimation(animation, forKey:"path")
		CATransaction.commit()
		
		hidden = false
	}
	
	func circleHide(speed: CFTimeInterval, altView: UIView? = nil)
	{
		let mask = CAShapeLayer()
		let size = max(bounds.width, bounds.height)
		mask.path = makeCirclePath(CGRect(x: bounds.midX - (size / 2), y: bounds.midY - (size / 2), width: size, height: size))
		mask.fillColor = UIColor.blackColor().CGColor
		
		layer.mask = mask
		
		CATransaction.begin()
		let animation = CABasicAnimation(keyPath: "path")
		animation.duration = speed
		animation.fillMode = kCAFillModeForwards
		animation.removedOnCompletion = false
		
		let newPath = makeCirclePath(CGRect(x: bounds.midX, y: bounds.midY, width: 0, height: 0))
		
		animation.fromValue = mask.path
		animation.toValue = newPath
		
		CATransaction.setCompletionBlock() {
			self.hidden = true
			self.layer.mask = nil
			if let view = altView
			{
				view.hidden = false
			}
		}
		mask.addAnimation(animation, forKey:"path")
		CATransaction.commit()
	}
}