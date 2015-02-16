//
//  RecordVC.swift
//  Perspective
//
//  Created by Apprentice on 2/15/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import MobileCoreServices


class RecordVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    
    override func viewDidAppear(animated: Bool) {
        
        captureSession.sessionPreset = AVCaptureSessionPreset640x480
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            
            println("captureVideoPressed and camera available.")
            
            var imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            
            imagePicker.sourceType = .Camera;
            
            imagePicker.mediaTypes = [kUTTypeMovie!]
            
            imagePicker.allowsEditing = true
            
            imagePicker.showsCameraControls = true
            
            self.presentViewController(imagePicker, animated: true, completion: nil)
            
        }
        else {
            println("Camera not available.")
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {
        
        
        let tempImage = info[UIImagePickerControllerMediaURL] as NSURL!
        let pathString = tempImage.relativePath
        let fileUrl = info[UIImagePickerControllerMediaURL] as NSURL!
        // UIImageJPEGRepresentation(self.image, 1).writeToURL(fileUrl, atomically: true)
        // var indent:NSString = "closr"
        var uploadRequest:AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = "theperspectiveapp"
        uploadRequest.key = "testfile2.mp4"
        uploadRequest.contentType = "video/mp4"
        uploadRequest.body = fileUrl
        uploadRequest.uploadProgress = { (bytesSent:Int64, totalBytesSent:Int64,  totalBytesExpectedToSend:Int64) -> Void in
            dispatch_sync(dispatch_get_main_queue(), {() -> Void in
                println(totalBytesSent)
            })
        }
        
        AWSS3TransferManager.defaultS3TransferManager().upload(uploadRequest).continueWithBlock { (task) -> AnyObject! in
            if (task.error != nil) {
                //failed
                println("failed")
                println(task.error.code)
                println(task.error.localizedDescription)
            } else {
                //completed
                println("completed")
            }
            return nil
        }
        
        self.dismissViewControllerAnimated(true, completion: {})
        
        UISaveVideoAtPathToSavedPhotosAlbum(pathString, self, nil, nil)
        
        
    }
}