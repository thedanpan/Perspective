//
//  PerspectiveFieldsVC.swift
//  Perspective
//
//  Created by Apprentice on 2/15/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class PerspectiveFieldsVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var theme: UITextField!
    @IBOutlet weak var numOfClips: UITextField!
    @IBOutlet weak var searchFriends: UISearchBar!
    @IBOutlet weak var submit: UIButton!
    var url: String!
    var toUser: String!

    @IBOutlet weak var txtIncompleteFieldsMessage: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        theme.endEditing(true)
        numOfClips.endEditing(true)
    }
    
    @IBAction func submitPerspectiveFields(sender: AnyObject) {
        var themeEntered = theme.text
        var numOfClipsEntered = numOfClips.text.toInt()
        
        func createPerspective(){
            var perspective = PFObject(className: "Perspective")
            perspective["theme"] = themeEntered
            perspective["numOfClips"] = numOfClipsEntered
            perspective["collaborators"] = [PFUser.currentUser().username]
            perspective["videos"] = [url]
            
            perspective.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    var perspectiveId = perspective.objectId
                    self.createNotification(perspectiveId)
                    println("Sucessfully saved Perspective")
                } else {
                    println("Perspective did not save")
                }
            }
        }
        
        if themeEntered != "" && numOfClipsEntered != nil {
            createPerspective()
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            self.txtIncompleteFieldsMessage.text = "All Fields Required"
        }
     
    }
    
    func createNotification(perspectiveId: String) {
        var notification = PFObject(className: "Notification")
        notification["fromUser"] = PFUser.currentUser().username
        notification["toUser"] = "darrin"
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
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