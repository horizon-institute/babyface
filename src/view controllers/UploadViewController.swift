//
//  UploadViewController.swift
//  babyface
//
//  Created by Kevin Glover on 21/04/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import Foundation
import UIKit
import CoreTelephony

extension NSMutableData
{
	func append(value: String)
	{
		if let data = value.dataUsingEncoding(NSUTF8StringEncoding)
		{
			appendData(data)
		}
	}
}

class UploadViewController: PageViewController
{
	@IBOutlet weak var uploadActivity: UIActivityIndicatorView!
	@IBOutlet weak var uploadProgress: UIProgressView!
	@IBOutlet weak var uploadButton: UIButton!
	@IBOutlet weak var statusText: UILabel!
	@IBOutlet weak var errorText: UILabel!
	@IBOutlet weak var shareButton: UIButton!
	
	var uploadStarted = false
	
	init()
	{
		super.init(nib: "UploadView")
	}
	
	required init?(coder aDecoder: NSCoder)
	{
		super.init(coder: aDecoder)
	}
	
	override var prevPage: Bool
	{
		return !uploadStarted
	}
	
	override var trim: Bool
	{
		return !uploadStarted
	}
	
	@IBAction func share(sender: UIButton)
	{
		let shareText = "We’ve just helped @GestStudy in their research to automatically calculate the gestational age of premature babies. You can help, too!"
		
		if let shareURL = NSURL(string: "http://cvl.cs.nott.ac.uk/resources/babyface/index.html")
		{
			let objectsToShare = [shareText, shareURL]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			
			self.presentViewController(activityVC, animated: true, completion: nil)
		}
	}
	
	@IBAction func startUpload(sender: AnyObject)
	{
		uploadStarted = true
		pageController?.update()
		pageController?.parameters["country"] = getCountry()
		let urlRequest = urlRequestWithComponents("http://www.cs.nott.ac.uk/babyface/upload.php", parameters: pageController!.parameters)
		
		statusText.hidden = true
		uploadActivity.alpha = 0
		uploadActivity.hidden = false
		uploadProgress.progress = 0
		uploadProgress.alpha = 0
		uploadProgress.hidden = false
		uploadButton.hidden = true
		statusText.hidden = false
		statusText.text = "Uploading"
		UIView.animateWithDuration(1, animations: {
			self.uploadActivity.alpha = 1
			self.uploadProgress.alpha = 1
		})
		
		UIApplication.sharedApplication().networkActivityIndicatorVisible = true
		upload(urlRequest.0, data: urlRequest.1)
			.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
				NSLog("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
				self.uploadProgress.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)

			}
			.response { (request, response, JSON, error) in
				print("REQUEST \(request)")
				print("RESPONSE \(response)")
				print("JSON \(JSON)")
				print("ERROR \(error)")
				// TODO Handle error/
				self.uploadProgress.hidden = true
				self.uploadActivity.hidden = true
				self.uploadActivity.stopAnimating()
				UIApplication.sharedApplication().networkActivityIndicatorVisible = false
				if let errorValue = error as? NSError
				{
					self.statusText.text = "Error uploading"
					self.errorText.text = errorValue.localizedDescription
					self.errorText.hidden = false

					self.uploadButton.hidden = false
					self.uploadButton.setTitle("Retry Upload", forState: .Normal)
				}
				else if response?.statusCode != 200
				{
					self.statusText.text = "Error uploading"
					self.errorText.hidden = false
					
					self.uploadButton.hidden = false
					self.uploadButton.setTitle("Retry Upload", forState: .Normal)
				}
				else
				{
					self.statusText.text = "Thank you for helping!"
					self.shareButton.hidden = false
				}
		}
	}
	
	func getCountry() -> String
	{
		let networkInfo = CTTelephonyNetworkInfo()
		let carrier = networkInfo.subscriberCellularProvider
		
		// Get carrier name
		var country = carrier!.isoCountryCode
		if country != nil
		{
			return country!
		}
		
		country = NSLocale.currentLocale().objectForKey(NSLocaleCountryCode) as? String
		if country != nil
		{
			return country!
		}
		
		return ""
	}
	
	func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData)
	{
		let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"

		mutableURLRequest.HTTPMethod = Method.POST.rawValue
		mutableURLRequest.setValue("multipart/form-data;boundary="+boundaryConstant, forHTTPHeaderField: "Content-Type")
		
		let uploadData = NSMutableData()	
		
		for (key, value) in parameters
		{
			uploadData.append("\r\n--\(boundaryConstant)\r\n")
			
			if let postData = value as? NSData
			{
				uploadData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(key).jpg\"\r\n")
				uploadData.append("Content-Type: image/jpeg)\r\n\r\n")
				uploadData.appendData(postData)
			}
			else
			{
				
				NSLog("\(key) = \(value)")
				uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
			}
		}
		uploadData.append("\r\n--\(boundaryConstant)--\r\n")
		
		return (ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
	}
}