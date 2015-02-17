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
    @IBOutlet weak var playback: UIButton!
    
    func displayUsername(){
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            usernameText.text = "Welcome, " + currentUser.username
            logoutButton.hidden = false
            newPerspective.hidden = false
            loginButton.hidden = true
        } else {
            usernameText.text = ""
            logoutButton.hidden = true
            loginButton.hidden = false
            newPerspective.hidden = true
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
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func logout(sender: UIButton) {
        PFUser.logOut()
        var currentUser = PFUser.currentUser()
        if let navController = self.navigationController {
            navController.popViewControllerAnimated(true)
        }
        displayUsername()
    }
    
    @IBAction func unwindToDash(segue: UIStoryboardSegue) {
    }
    
    @IBAction func gotoPlayback(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PlaybackVC") as PlaybackVC
        self.navigationController?.pushViewController(vc, animated: true)
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
