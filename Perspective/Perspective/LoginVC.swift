//
//  LoginVC.swift
//  Perspective
//
//  Created by Apprentice on 2/13/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var txtIncompleteFieldsMessage: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var displayUsername: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
            self.displayUsername.text = currentUser.username
        } else {
            // Show the signup or login screen
        }
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signinTapped(sender: UIButton) {
        // Authentication Code
        
        var usrEntered = txtUsername.text
        var pwdEntered = txtPassword.text
        
        func userLogIn(){
            PFUser.logInWithUsernameInBackground(usrEntered, password:pwdEntered) {
                    (user: PFUser!, error: NSError!) -> Void in
                        if user != nil {
                            self.dismissViewControllerAnimated(true, completion: nil)
                            self.txtIncompleteFieldsMessage.text = "Logged in!"
                        } else {
                            self.txtIncompleteFieldsMessage.text = "The login failed. Check error to see why."
                        }
                }
        }
            
        if usrEntered != "" && pwdEntered != "" {
           userLogIn()
        } else {
           self.txtIncompleteFieldsMessage.text = "All Fields Required"
        }
       
    }
    
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */



