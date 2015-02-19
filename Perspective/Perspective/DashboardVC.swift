//
//  DashboardVC.swift
//  Perspective
//
//  Created by Apprentice on 2/14/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableData : [String] = ["Darrin", "Dionne", "Scott", "Dani"]
    @IBOutlet weak var usernameText: UILabel!

    @IBOutlet weak var logoutButton: UIButton!

    @IBOutlet weak var newPerspective: UIButton!

    @IBOutlet weak var loginButton: UIButton!

    @IBOutlet weak var signupButton: UIButton!

    @IBOutlet weak var playbackButton: UIButton!

    @IBOutlet var noteStream: UITableView!

    @IBOutlet var timeStream: UITableView!
    
    var notificationQuery : [Note] = []

    var timelineQuery : [Timeline] = []

    func displayUsername(){
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            usernameText.text = "Welcome, " + currentUser.username
            logoutButton.hidden = false
            newPerspective.hidden = false
            loginButton.hidden = true
            signupButton.hidden = true
            noteStream.hidden = false
            timeStream.hidden = false
            var nib = UINib(nibName: "NoteCellNib", bundle: nil)
            noteStream.registerNib(nib, forCellReuseIdentifier: "nCell")
            
            var notificationQuery = PFQuery(className: "Notification")
            notificationQuery.whereKey("toUser", equalTo: currentUser.username)

            var notificationQueryArray = notificationQuery.findObjects()

            var notificationArray : [Note] = []

            for n in notificationQueryArray {
                var note : Note = Note(fromUser: n.valueForKey("fromUser") as String, toUser: n.valueForKey("toUser") as String, notificationType: n.valueForKey("notificationType") as String)

                if n.valueForKey("perspectiveId") != nil
                    {
                        note.perspectiveId = n.valueForKey("perspectiveId") as? String
                    }
                notificationArray.append(note)
            }

            self.notificationQuery = notificationArray
            
            var tib = UINib(nibName: "TimelineCellNib", bundle: nil)
            timeStream.registerNib(tib, forCellReuseIdentifier: "tCell")
            
            var timelineQuery = PFQuery(className: "Perspective")
            timelineQuery.whereKey("complete", equalTo: true)
            timelineQuery.whereKey("collaborators", equalTo: currentUser.username)
            
            var timelineQueryArray = timelineQuery.findObjects()
            
            var timelineArray : [Timeline] = []
            
            for t in timelineQueryArray {
                var timeline : Timeline = Timeline(theme: t.valueForKey("theme") as String, perspectiveId: t.valueForKey("objectId") as String)
                timelineArray.append(timeline)
            }
            
            self.timelineQuery = timelineArray

        } else {
            usernameText.text = ""
            logoutButton.hidden = true
            loginButton.hidden = false
            newPerspective.hidden = true
            signupButton.hidden = false
            noteStream.hidden = true
            timeStream.hidden = true
        }
    }

    override func viewWillAppear(animated: Bool) {
        displayUsername()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
        } else {
            usernameText.text = ""
        }

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "signupReload:", name:"signedUp", object: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginReload:", name:"loggedIn", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "whosNextReload:", name:"whosNext", object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == self.noteStream){
        return self.notificationQuery.count
        }
        else {
        return self.timelineQuery.count
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if(tableView == self.noteStream){
        var cell : NoteCell = self.noteStream.dequeueReusableCellWithIdentifier("nCell") as NoteCell
        cell.noteLabel.text = self.notificationQuery[indexPath.row].notificationType as String
        return cell
        }
        else {
        var cell : TimelineCell = self.timeStream.dequeueReusableCellWithIdentifier("tCell") as TimelineCell
        cell.timeLabel.text =  self.timelineQuery[indexPath.row].theme as String
        return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("Row selected")
        if(tableView == self.noteStream){
            if self.notificationQuery[indexPath.row].notificationType as String == "invite"{
               var perspectiveId = self.notificationQuery[indexPath.row].perspectiveId as String!
                gotoPlayback(perspectiveId, isComplete: false)
            }
            else if self.notificationQuery[indexPath.row].notificationType as String == "complete"{
               var perspectiveId = self.notificationQuery[indexPath.row].perspectiveId as String!
                gotoPlayback(perspectiveId, isComplete: true)
            }
            else {

            }
        }
        else {
            var perspectiveId = self.timelineQuery[indexPath.row].perspectiveId as String!
            gotoPlayback(perspectiveId, isComplete: true)
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }



    func signupReload(notification: NSNotification){
        //load data here
        self.reloadInputViews()
    }

    func loginReload(notification: NSNotification){
        //load data here
        self.reloadInputViews()
    }
    
    func whosNextReload(notification: NSNotification){
        //load data here
        self.reloadInputViews()
    }

    @IBAction func logout(sender: UIButton) {
        PFUser.logOut()
//        if let navController = self.navigationController {
//            navController.popViewControllerAnimated(true)
//        }
        displayUsername()
    }

    @IBAction func gotoLogin(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LoginVC") as LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func signupTapped(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignupVC") as SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }

    func gotoPlayback(perspective: String, isComplete: Bool) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PlaybackVC") as PlaybackVC

        vc.perspectiveId = perspective
        vc.playingCompletedPerspective = isComplete

        self.navigationController?.pushViewController(vc, animated: true)
        println("Leaving DashboardVC, pushing PlaybackVC.")
    }

    @IBAction func gotoRecord(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("RecordVC") as RecordVC
        vc.newPerspective = true
        self.navigationController?.pushViewController(vc, animated: true)
        println("Leaving DashboardVC, pushing RecordVC.")
    }

}
