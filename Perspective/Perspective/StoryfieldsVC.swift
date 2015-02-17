//
//  StoryfieldsVC.swift
//  Perspective
//
//  Created by Apprentice on 2/15/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class StoryfieldsVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var theme: UITextField!
    @IBOutlet weak var clipDuration: UITextField!
    @IBOutlet weak var numOfClips: UITextField!
    @IBOutlet weak var searchFriends: UISearchBar!
    var url: String!

    @IBOutlet weak var txtIncompleteFieldsMessage: UILabel!
    
    
    @IBAction func submitStoryfields(sender: AnyObject) {
        var themeEntered = theme.text
        var clipDurationEntered = clipDuration.text.toInt()
        var numOfClipsEntered = numOfClips.text.toInt()
        
        func createStory(){
            var currentUser = PFUser.currentUser()
            
            var story = PFObject(className: "Story")
            story["theme"] = themeEntered
            story["clipDuration"] = clipDurationEntered
            story["numOfClips"] = numOfClipsEntered
            story["owner"] = currentUser.username
            story["sender"] = currentUser.username
            story["receiver"] = ""
            story.addUniqueObjectsFromArray([url], forKey:"videos")
            
            story.saveInBackgroundWithBlock {
                (success: Bool, error: NSError!) -> Void in
                if (success) {
                    println("Sucessfully saved story")
                } else {
                    println("Story did not save")
                }
            }
        }
        
        if themeEntered != "" && clipDurationEntered != nil && numOfClipsEntered != nil {
            createStory()
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            self.txtIncompleteFieldsMessage.text = "All Fields Required"
        }
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        println("the url is: \(self.url)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        theme.endEditing(true)
        clipDuration.endEditing(true)
        numOfClips.endEditing(true)
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