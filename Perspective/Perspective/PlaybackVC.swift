//
//  PlaybackVC.swift
//  Perspective
//
//  Created by Apprentice on 2/16/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import AVKit
import MediaPlayer

class PlaybackVC: AVPlayerViewController { // UIViewController
    
    var perspectiveId : String!
    var videoList : [AVPlayerItem] = []
    var playingCompletedPerspective : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var perspective = loadPerspectiveVideos()
        var videosArray:NSArray = perspective["videos"] as NSArray
        for item in videosArray{
            var urlStr = NSURL(string: item as String)
            self.videoList.append(AVPlayerItem(URL: urlStr))
        }
        playVideos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPerspectiveVideos() -> (PFObject) {
        var query = PFQuery(className:"Perspective")
        var perspectiveObject = query.getObjectWithId(perspectiveId)
        return perspectiveObject
    }
    
    func playVideos() {
        println("Inside playVideos \(videoList)")
        
        let player = AVQueuePlayer(items: videoList)
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "stop", name: "AVPlayerItemDidPlayToEndTimeNotification", object: videoList.last)
        player.play()
    }
    
    func stop(){
        self.player = nil;
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "AVPlayerItemDidPlayToEndTimeNotification", object: nil)
        self.dismissViewControllerAnimated(false, completion: nil)
        if playingCompletedPerspective == true {
            self.deleteNotification(perspectiveId)
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RecordVC") as RecordVC
            vc.newPerspective = false
            vc.perspectiveId = perspectiveId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func deleteNotification(perspectiveId: String) {
        var query = PFQuery(className: "Notification")
        query.whereKey("toUser", equalTo:PFUser.currentUser().username)
        query.whereKey("perspectiveId", equalTo:perspectiveId)
        query.findObjectsInBackgroundWithBlock {
            (notifications: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                NSLog("Successfully retrieved \(notifications.count) notifications.")
                for notification in notifications {
                    notification.deleteInBackground()
                }
            } else {
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
}

