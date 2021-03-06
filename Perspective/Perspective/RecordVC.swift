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
    let date = NSDate()

    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice : AVCaptureDevice?
    var currentUser = PFUser.currentUser()
    var newPerspective : Bool!
    var perspectiveId : String!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        captureSession.sessionPreset = AVCaptureSessionPreset1280x720

        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            println("captureVideoPressed and camera available.")
            var imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .Camera;
            imagePicker.mediaTypes = [kUTTypeMovie!]
            imagePicker.allowsEditing = true
            imagePicker.showsCameraControls = true
            self.presentViewController(imagePicker, animated: false, completion: nil)
        }
        else {
            println("Camera not available.")
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.navigationController?.popToRootViewControllerAnimated(true)
        println("Video cancel button tapped, pop to root VC.")
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingMediaWithInfo info:NSDictionary!) {

        let timestamp = date.timeIntervalSince1970
        let tempImage = info[UIImagePickerControllerMediaURL] as NSURL!
        let pathString = tempImage.relativePath
        let fileUrl = info[UIImagePickerControllerMediaURL] as NSURL!
        var uploadRequest:AWSS3TransferManagerUploadRequest = AWSS3TransferManagerUploadRequest()
        uploadRequest.bucket = "theperspectiveapp"
        uploadRequest.key = "\(timestamp).mp4"
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
//                self.createVideoParseObj(uploadRequest.key)
            }
            return nil
        }
//        println("view stack= \(self.view)")
        
        if newPerspective == true {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PerspectiveFieldsVC") as PerspectiveFieldsVC
            vc.url = "https://s3.amazonaws.com/theperspectiveapp/\(uploadRequest.key)"
            self.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            println("Leaving RecordVC, pushing PerspectiveFieldsVC")
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("WhosNextVC") as WhosNextVC
            vc.url = "https://s3.amazonaws.com/theperspectiveapp/\(uploadRequest.key)"
            vc.perspectiveId = perspectiveId
            self.dismissViewControllerAnimated(true, completion: nil)
            self.navigationController?.pushViewController(vc, animated: true)
            println("Leaving RecordVC, pushing WhosNextVC")
        }
    }

}
