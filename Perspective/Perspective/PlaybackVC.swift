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
    
//    var storyObjectId : String!    WILL TAKE IN STORY ID FROM DASHBOARD
    var storyObjectId = "2VxXrXOBn4"
    var videoList : [AVPlayerItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var story = loadStoryVideos()
        var videosArray:NSArray = story["videos"] as NSArray
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
    
    func loadStoryVideos() -> (PFObject) {
        var query = PFQuery(className:"Story")
        var storyObject = query.getObjectWithId(storyObjectId)
        return storyObject
    }
    
    func playVideos() {
        println("Inside playVideos \(videoList)")
        
        let player = AVQueuePlayer(items: videoList)
        let playerController = AVPlayerViewController()
        
        playerController.player = player
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)
        playerController.view.frame = self.view.frame

        player.play()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

