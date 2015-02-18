//
//  SignupVC.swift
//  Perspective
//
//  Created by Apprentice on 2/13/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class SignupVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtIncompleteFieldsMessage: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var returnToLogin: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().postNotificationName("signedUp", object: nil)
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
        txtEmail.endEditing(true)
        txtPassword.endEditing(true)
    }
    
    @IBAction func loginVerifyButton(sender: AnyObject){
        
        var usrEntered = txtUsername.text
        var pwdEntered = txtPassword.text
        var emlEntered = txtEmail.text
        
        func userSignUp(){
            var user = PFUser()
            user.username = usrEntered
            user.password = pwdEntered
            user.email = emlEntered
            
            user.signUpInBackgroundWithBlock {
                (succeded: Bool!, error: NSError!) -> Void in
                if error == nil {
                    //Hooray!
                    self.txtIncompleteFieldsMessage.text = "User Signed Up"
                    self.navigationController!.popToRootViewControllerAnimated(true)
                } else {
                    //Show the errorString
                }
            }
        }
        
        if usrEntered != "" && pwdEntered != "" && emlEntered != "" {
            userSignUp()
        } else {
            self.txtIncompleteFieldsMessage.text = "All Fields Required"
        }
    }

    @IBAction func gotoLogin(sender: AnyObject) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController?.popToViewController(viewControllers[viewControllers.count - 2], animated: true)
    }
}
