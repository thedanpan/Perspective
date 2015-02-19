//
//  WhosNextVC.swift
//  Perspective
//
//  Created by Apprentice on 2/17/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class WhosNextVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet var contactList: UIPickerView!
    
    var url: String!
    var perspectiveId: String!
    var toUser : String!
   var friends : [String] = []
    var pickedFriend: String!
    
    func queryFriends() {
        var query = PFUser.query()
        var user = query.findObjects()
        
        for friend in user {
            var string:String = friend.valueForKey("username") as String
            friends.append(string)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        queryFriends()
        NSNotificationCenter.defaultCenter().postNotificationName("whosNext", object: nil)
        contactList.delegate = self
        contactList.dataSource = self
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return friends[row]
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return friends.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickedFriend = friends[row]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setPerspectiveComplete(perspective: PFObject) {
        perspective["complete"] = true
        perspective.saveInBackground()
    }
    
    @IBAction func queryPerspective (sender: UIButton) {
        var query = PFQuery(className: "Perspective")
        query.getObjectInBackgroundWithId(self.perspectiveId) {
            (perspective: PFObject!, error: NSError!) -> Void in
            if error != nil {
                NSLog("%@", error)
                println("Error, Perspective not retrieved.")
            } else {
                perspective.addObject(PFUser.currentUser().username, forKey: "collaborators")
                perspective.addObject(self.url, forKey: "videos")
                perspective.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError!) -> Void in
                    if (success) {
                        var perspectiveId = perspective.objectId
                        var collaborators: NSArray = perspective["collaborators"] as NSArray
                        let videosArray:NSArray = perspective["videos"] as NSArray
                        let videosArrayCount: Int = videosArray.count
                        println(videosArrayCount)
                        let perspectiveNumOfClips: Int = perspective["numOfClips"] as Int
                        println(perspectiveNumOfClips)
                        if perspectiveNumOfClips == videosArrayCount {
                            self.createCompleteNotification(perspectiveId, collaborators: collaborators)
                            self.deleteNotification(perspectiveId)
                            self.setPerspectiveComplete(perspective)
                          } else {
                            println("Inside completion check - else")
                            self.createNextNotification(perspectiveId)
                            self.deleteNotification(perspectiveId)
                          }
                    } else {
                        NSLog("%@", error)
                        println("Error, Perspective not updated.")
                    }
                }
            }
                self.navigationController?.popToRootViewControllerAnimated(true)
                println("Perspective updating in background, pop to root VC.")
        }
    }
    
    func createNextNotification(perspectiveId: String) {
        var notification = PFObject(className: "Notification")
        notification["fromUser"] = PFUser.currentUser().username
        notification["toUser"] = pickedFriend
        notification["notificationType"] = "invite"
        notification["perspectiveId"] = perspectiveId
        notification.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if (success) {
                println("Sucessfully saved Notification")
            } else {
                println("Notification did not save")
            }
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
    
    func createCompleteNotification(perspectiveId: String, collaborators: NSArray) {
        for user in collaborators {
            var notification = PFObject(className: "Notification")
            notification["fromUser"] = PFUser.currentUser().username
            notification["toUser"] = user as String
            notification["notificationType"] = "invite"
            notification["perspectiveId"] = perspectiveId
            notification.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    println("Sucessfully saved Notification")
                } else {
                    println("Notification did not save")
                }
            }
            println("Perspective complete notification successfully created.")
        }
    }
}
