//
//  CameraViewController.swift
//  babyface
//
//  Created by Kevin Glover on 30/03/2015.
//  Copyright (c) 2015 Horizon. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: PageViewController
{
	@IBOutlet weak var cameraView: UIView!
	let captureSession = AVCaptureSession()
	var previewLayer : AVCaptureVideoPreviewLayer?
	var captureDevice : AVCaptureDevice?
	let stillImageOutput = AVCaptureStillImageOutput()
 
	override var nextPage: Bool
	{
		return self.pageController?.babyData.images[photoName] != nil
	}
	
	var photoName: String
	{
		let endIndex = advance(restorationIdentifier!.startIndex, 3)
		return restorationIdentifier!.substringToIndex(endIndex)
	}
	
	@IBAction func takePicture(sender: AnyObject)
	{
		stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
		if captureSession.canAddOutput(stillImageOutput)
		{
			captureSession.addOutput(stillImageOutput)
		}
		
		var videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo)
		if videoConnection != nil
		{
			stillImageOutput.captureStillImageAsynchronouslyFromConnection(stillImageOutput.connectionWithMediaType(AVMediaTypeVideo))
				{ (imageDataSampleBuffer, error) -> Void in
					var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer as CMSampleBuffer)
					if imageData != nil
					{
						self.pageController?.babyData.images[self.photoName] = imageData;
						self.pageController?.nextPage(self)
					}
				}
		}
	}
	
	override func viewDidAppear(animated: Bool)
	{
		captureSession.sessionPreset = AVCaptureSessionPresetHigh
		
		let devices = AVCaptureDevice.devices()
		
		for device in devices
		{
			if (device.hasMediaType(AVMediaTypeVideo))
			{
				if(device.position == AVCaptureDevicePosition.Back)
				{
					captureDevice = device as? AVCaptureDevice
					if captureDevice != nil
					{
						if let device = captureDevice
						{
							device.lockForConfiguration(nil)
							device.focusMode = .ContinuousAutoFocus
							device.exposureMode = .ContinuousAutoExposure
							device.whiteBalanceMode = .ContinuousAutoWhiteBalance
							device.flashMode = .Auto
							device.unlockForConfiguration()
						}
						
						var err : NSError? = nil
						var deviceInput = AVCaptureDeviceInput(device: captureDevice, error: &err)
						if captureSession.canAddInput(deviceInput)
						{
							captureSession.addInput(deviceInput)
						}
						
						if err != nil
						{
							NSLog("error: \(err!.localizedDescription)")
						}
						
						previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
						previewLayer?.frame = view.bounds
						previewLayer?.videoGravity = AVLayerVideoGravityResizeAspect
						cameraView.layer.addSublayer(previewLayer)
						
						captureSession.startRunning()
					}
				}
			}
		}
	}
	
	override func viewWillDisappear(animated: Bool)
	{
		captureSession.stopRunning()
	}
}