//
//  SignupVC.swift
//  Perspective
//
//  Created by Apprentice on 2/13/15.
//  Copyright (c) 2015 Dev Bootcamp. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {

    @IBOutlet weak var txtIncompleteFieldsMessage: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
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
                    let dash = DashboardVC()
                    let navController = UINavigationController(rootViewController: dash)
                    navController.popToRootViewControllerAnimated(false)
                    self.txtIncompleteFieldsMessage.text = "User Signed Up";
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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func gotoLogin(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
