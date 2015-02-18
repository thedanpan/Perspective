//
//  WhosNextVC.swift
//  Perspective
//
//  Created by Apprentice on 2/17/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class WhosNextVC: UIViewController {
    
//    @IBOutlet weak var instructionsText: UILabel!
    
    var url: String!
    var perspectiveId: String!
    var receiver : String?

    override func viewDidLoad() {
        super.viewDidLoad()

//        instructionsText.text = "Pick the next collaborator"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func gotoPickCollaborator(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PickCollaboratorVC") as PickCollaboratorVC
        self.navigationController?.pushViewController(vc, animated: true)
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
                        let videosArray:NSArray = perspective["videos"] as NSArray
                        let videosArrayCount: Int = videosArray.count
                        println(videosArrayCount)
                        let perspectiveNumOfClips: Int = perspective["numOfClips"] as Int
                        println(perspectiveNumOfClips)
                        if perspectiveNumOfClips == videosArrayCount {
//                          CREATE COMPLETION NOTIFICATION
                            println("Inside completion check - if")
                            self.setPerspectiveComplete(perspective)
                          } else {
                            println("Inside completion check - else")
//                          CREATE NOTIFICATION FOR NEXT COLLABORATOR
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
}
