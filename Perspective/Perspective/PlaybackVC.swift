//
//  PlaybackVC.swift
//  Perspective
//
//  Created by Apprentice on 2/16/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaybackVC: UIViewController {
    
//    var storyObjectId : String!    WILL TAKE IN STORY ID FROM DASHBOARD
    var storyObjectId = "2VxXrXOBn4"
    var moviePlayer : MPMoviePlayerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var story = loadStoryVideos()
        let videosArray : AnyObject = story["videos"]
        var videoUrl = videosArray[0] as String
        //var (localUrl, localPath) =
        getVideosFromS3(videoUrl)
        // playVideo(localUrl, localPath: localPath)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getVideosFromS3(video: String) { //-> (NSURL, NSString) {
        let downloadingFilePath = NSTemporaryDirectory().stringByAppendingPathComponent("movie.m4v")
        let downloadingFileURL = NSURL(fileURLWithPath: downloadingFilePath)
        let downloadRequest : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        downloadRequest.bucket = "theperspectiveapp"
        downloadRequest.key =  "testfile2.mp4"
        downloadRequest.downloadingFileURL = downloadingFileURL
        
        //let readRequest1 : AWSS3TransferManagerDownloadRequest = AWSS3TransferManagerDownloadRequest()
        
        let transferManager = AWSS3TransferManager.defaultS3TransferManager()
        
        let task = transferManager.download(downloadRequest)
        task.continueWithBlock { (task) -> AnyObject! in
            println(task.error)
            if task.error != nil {
            } else {
                println("Fetched video")
                println(downloadingFileURL!)
                var urlString = downloadingFileURL!.absoluteString
                self.playVideo(downloadingFileURL!) // (downloadingFileURL!, localPath: downloadingFilePath)            }
            }
            return nil
        }
    }
    
    func loadStoryVideos() -> (PFObject) {
        var query = PFQuery(className:"Story")
        var storyObject = query.getObjectWithId(storyObjectId)
        return storyObject
    }
    
    func playVideo(video: NSURL) {
        var url:NSURL! = video   // NSURL(string: video)
        
        moviePlayer = MPMoviePlayerController(contentURL: url)
        
        moviePlayer.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        moviePlayer.view.sizeToFit()
        
        self.view.addSubview(moviePlayer.view)
        
        moviePlayer.fullscreen = true
        
        moviePlayer.controlStyle = MPMovieControlStyle.Embedded
    }
    
//    func playVideo(localUrl: NSURL, localPath: String) {
//        println("Got to playVideo function")
////        let path =  NSBundle.mainBundle().pathForResource(localPath, ofType:"m4v")
//        let url =  localUrl //NSURL.fileURLWithPath(localUrl)
//        moviePlayer = MPMoviePlayerController(contentURL: url)
//        if let player = moviePlayer {
//            player.view.frame = self.view.bounds
//            player.prepareToPlay()
//            player.scalingMode = .AspectFill
//            self.view.addSubview(player.view)
//        }
//    }
    

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

