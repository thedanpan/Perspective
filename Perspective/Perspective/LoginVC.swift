//
//  LoginVC.swift
//  Perspective
//
//  Created by Apprentice on 2/13/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var txtIncompleteFieldsMessage: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().postNotificationName("loggedIn", object: nil)
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            // Do stuff with the user
        } else {
            // Show the signup or login screen
        }
        
        // Do any additional setup after loading the view.
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
        txtUsername.endEditing(true)
        txtPassword.endEditing(true)
    }
    
    @IBAction func signinTapped(sender: UIButton) {
        // Authentication Code
        
        var usrEntered = txtUsername.text
        var pwdEntered = txtPassword.text
        
        func userLogIn() {
            PFUser.logInWithUsernameInBackground(usrEntered, password:pwdEntered) {
                (user: PFUser!, error: NSError!) -> Void in
                if user != nil {
                    self.txtIncompleteFieldsMessage.text = "Log in successful."
                    self.navigationController?.popToRootViewControllerAnimated(true)
                } else {
                    self.txtIncompleteFieldsMessage.text = "Log in failed. Please try again."
                }
            }
        }
        
        if usrEntered != "" && pwdEntered != "" {
            userLogIn()
        } else {
            self.txtIncompleteFieldsMessage.text = "All Fields Required"
        }
        
    }
    
    @IBAction func signupTapped(sender: UIButton) {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SignupVC") as SignupVC
        self.navigationController?.pushViewController(vc, animated: true)
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



