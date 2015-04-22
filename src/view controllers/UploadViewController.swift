//
//  UploadViewController.swift
//  babyface
//
//  Created by Kevin Glover on 21/04/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import Foundation
import UIKit

class UploadViewController: CameraOutputViewController
{
	@IBOutlet weak var uploadProgress: UIProgressView!
	@IBOutlet weak var uploadButton: UIButton!
	@IBOutlet weak var statusText: UILabel!
	
	@IBAction func share(sender: UIButton)
	{
		let shareText = "We’ve just helped the University of Nottingham in their research to automatically calculate the gestational age of premature babies. You can help, too!"
		
		if let shareURL = NSURL(string: "https://itunes.apple.com/us/app/babyface-data-collection/id980548726?ls=1&mt=8")
		{
			let objectsToShare = [shareText, shareURL]
			let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
			
			self.presentViewController(activityVC, animated: true, completion: nil)
		}
	}
	
	@IBAction func uploadImages(sender: AnyObject)
	{
		var parameters = [
			"face"		:NetData(data: pageController!.babyData.images["Fac"]!, mimeType: .ImageJpeg, filename: "face.jpg"),
			"foot"		:NetData(data: pageController!.babyData.images["Foo"]!, mimeType: .ImageJpeg, filename: "foot.jpg"),
			"ear"		:NetData(data: pageController!.babyData.images["Ear"]!, mimeType: .ImageJpeg, filename: "ear.jpg"),
			"weight"	:"\(pageController!.babyData.weight)",
			"age"		:"\(pageController!.babyData.age)",
			"due"		:"\(pageController!.babyData.due)",
			"gender"	:"\(pageController!.babyData.gender!)",
			"ethnicity"	:"\(pageController!.babyData.ethnicity)"
		]
		
		let urlRequest = self.urlRequestWithComponents("http://matrix.cs.nott.ac.uk/babyface/upload.php", parameters: parameters)
		
		statusText.hidden = true
		uploadProgress.progress = 0
		uploadProgress.alpha = 0
		uploadProgress.hidden = false
		uploadButton.enabled = false
		uploadButton.setTitle("Uploading", forState: .Normal)
		
		UIView.animateWithDuration(1, animations: {
			self.uploadProgress.alpha = 1.0
		})
		
		upload(urlRequest.0, urlRequest.1)
			.progress { (bytesWritten, totalBytesWritten, totalBytesExpectedToWrite) in
				println("\(totalBytesWritten) / \(totalBytesExpectedToWrite)")
				self.uploadProgress.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
			}
			.responseJSON { (request, response, JSON, error) in
				println("REQUEST \(request)")
				println("RESPONSE \(response)")
				println("JSON \(JSON)")
				println("ERROR \(error)")
				// TODO Handle error/
				self.uploadProgress.hidden = true
				if error != nil
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
				}
		}
	}
	
	func urlRequestWithComponents(urlString:String, parameters:NSDictionary) -> (URLRequestConvertible, NSData)
	{
		// create url request to send
		var mutableURLRequest = NSMutableURLRequest(URL: NSURL(string: urlString)!)
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
				var postData = value as! NetData
				
				// append content disposition
				var filenameClause = " filename=\"\(postData.filename)\""
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