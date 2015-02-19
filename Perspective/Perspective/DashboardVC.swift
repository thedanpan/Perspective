//
//  DashboardVC.swift
//  Perspective
//
//  Created by Apprentice on 2/14/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {
    
    @IBOutlet weak var usernameText: UILabel!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var newPerspective: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var playbackButton: UIButton!
    
    func displayUsername(){
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            usernameText.text = "Welcome, " + currentUser.username
            logoutButton.hidden = false
            newPerspective.hidden = false
            loginButton.hidden = true
            signupButton.hidden = true
        } else {
            usernameText.text = ""
            logoutButton.hidden = true
            loginButton.hidden = false
            newPerspective.hidden = true
            signupButton.hidden = false
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func signupReload(notification: NSNotification){
        //load data here
        self.reloadInputViews()
    }
    
    func loginReload(notification: NSNotification){
        //load data here
        self.reloadInputViews()
    }
    
    @IBAction func logout(sender: UIButton) {
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
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
    
    @IBAction func gotoPlayback(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PlaybackVC") as PlaybackVC
        vc.perspectiveId = "AJ7G5z7cnN"
        vc.playingCompletedPerspective = true
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
