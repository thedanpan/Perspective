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
    
    
    @IBAction func displayUsername(){
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            self.usernameText.text = currentUser.username
        } else {
            self.usernameText.text = "No current user!!"
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
    }
    
    
    @IBAction func unwindToDash(segue: UIStoryboardSegue) {
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
