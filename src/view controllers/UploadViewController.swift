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

class UploadViewController: CameraOutputViewController
{
	@IBOutlet weak var uploadActivity: UIActivityIndicatorView!
	@IBOutlet weak var uploadProgress: UIProgressView!
	@IBOutlet weak var uploadButton: UIButton!
	@IBOutlet weak var statusText: UILabel!
	@IBOutlet weak var retakeButton: UIButton!
	
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
		let parameters = [
			"face"		:NetData(data: pageController!.babyData.images["Fac"]!, mimeType: .ImageJpeg, filename: "face.jpg"),
			"foot"		:NetData(data: pageController!.babyData.images["Foo"]!, mimeType: .ImageJpeg, filename: "foot.jpg"),
			"ear"		:NetData(data: pageController!.babyData.images["Ear"]!, mimeType: .ImageJpeg, filename: "ear.jpg"),
			"weight"	:"\(pageController!.babyData.weight)",
			"gender"	:"\(pageController!.babyData.gender!)",
			"age"		:"\(pageController!.babyData.age)",
			"ethnicity"	:"\(pageController!.babyData.ethnicity!)",
			"due"		:"\(pageController!.babyData.due)",
			"country"	:getCountry()
		]
		
		let urlRequest = self.urlRequestWithComponents("http://www.cs.nott.ac.uk/babyface/upload.php", parameters: parameters)
		
		statusText.hidden = true
		uploadActivity.alpha = 0;
		uploadActivity.hidden = false
		uploadActivity.startAnimating()
		uploadProgress.progress = 0
		uploadProgress.alpha = 0
		uploadProgress.hidden = false
		uploadButton.enabled = false
		uploadButton.setTitle("Uploading", forState: .Normal)
		UIView.animateWithDuration(1, animations: {
			self.uploadActivity.alpha = 1.0
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
				if error != nil || response?.statusCode != 200
				{
					self.statusText.hidden = false
					self.statusText.text = "Error uploading"

					self.uploadButton.enabled = true
					self.uploadButton.setTitle("Retry Upload", forState: .Normal)
				}
				else
				{
					self.statusText.hidden = false
					self.statusText.text = "Thank you for helping!"
					self.uploadButton.enabled = true
					self.uploadButton.setTitle("Share", forState: .Normal)
					self.uploadButton.removeTarget(self, action: "uploadImages:", forControlEvents: .TouchUpInside)
					self.uploadButton.addTarget(self, action: "share:", forControlEvents: .TouchUpInside)
					self.retakeButton.hidden = true
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
		// create url request to send
		let mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		mutableURLRequest.HTTPMethod = Method.POST.rawValue
		//let boundaryConstant = "myRandomBoundary12345"
		let boundaryConstant = "NET-POST-boundary-\(arc4random())-\(arc4random())"
		let contentType = "multipart/form-data;boundary="+boundaryConstant
		mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
		
		
		// create upload data to send
		let uploadData = NSMutableData()
		
		// add parameters
		for (key, value) in parameters
		{
			uploadData.appendData("\r\n--\(boundaryConstant)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
			
			if value is NetData
			{
				// add image
				let postData = value as! NetData
				
				// append content disposition
				let filenameClause = " filename=\"\(postData.filename)\""
				let contentDispositionString = "Content-Disposition: form-data; name=\"\(key)\";\(filenameClause)\r\n"
				let contentDispositionData = contentDispositionString.dataUsingEncoding(NSUTF8StringEncoding)
				uploadData.appendData(contentDispositionData!)
				
				// append content type
				let contentTypeString = "Content-Type: \(postData.mimeType.getString())\r\n\r\n"
				let contentTypeData = contentTypeString.dataUsingEncoding(NSUTF8StringEncoding)
				uploadData.appendData(contentTypeData!)
				uploadData.appendData(postData.data)
			}
			else
			{
				uploadData.appendData("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
			}
		}
		uploadData.appendData("\r\n--\(boundaryConstant)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
		
		// return URLRequestConvertible and NSData
		return (ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0, uploadData)
	}
}