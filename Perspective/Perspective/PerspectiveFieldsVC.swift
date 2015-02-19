//
//  PerspectiveFieldsVC.swift
//  Perspective
//
//  Created by Apprentice on 2/15/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class PerspectiveFieldsVC: UIViewController, UITextFieldDelegate , UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var theme: UITextField!
    @IBOutlet weak var numOfClips: UITextField!
    @IBOutlet weak var searchFriends: UISearchBar!
    @IBOutlet weak var submit: UIButton!
    var url: String!
    var toUser: String!
    var friends = ["hello"]
    var pickedFriend: String!
    
    @IBOutlet weak var txtIncompleteFieldsMessage: UILabel!
    
    @IBOutlet var contactList: UIPickerView!
    
    
    override func viewWillAppear(animated: Bool) {
    
    }
    
    func queryFriends() {
        var query = PFUser.query()
        query.whereKey("username", equalTo: PFUser.currentUser().username)
        println(query)
        var user = query.findObjects()
        println(user)
        var friendList = user[0].valueForKey("friendList") as NSArray!
        
        println(friendList)
        
        for friend in friendList {
            var string:String = friend as String
            friends.append(string)
            println(friends)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryFriends()
        contactList.delegate = self
        contactList.dataSource = self
//        pickerView.dataSource = self
//        pickerView.delegate = self
//        pickerView.reloadAllComponents
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
    
    @IBAction func submitPerspectiveFields(sender: UIButton) {
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    

}