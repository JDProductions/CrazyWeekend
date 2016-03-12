//
//  ViewController.swift
//  thecrazyweekend
//
//  Created by James DuBois on 3/10/16.
//  Copyright © 2016 James DuBois. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    // If the user is logged in just take them to the logged in seguae
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
        }
    }
    
    @IBAction func faceBookButtonPressed(sender: UIButton) {
        let facebookLogin = FBSDKLoginManager()

        facebookLogin.logInWithReadPermissions(["email"],
                                                fromViewController:self, //<=== new addition, self is the view controller where you're calling this method.
            handler: { (result:FBSDKLoginManagerLoginResult!, error:NSError!) -> Void in
                if error != nil {
                    print("Facebook login failed. Error\(error)")
                    
                }
                else {
                    // Successfully login - etc fb creates access token and we get the token string
                    let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                    print("Successfully Logged in with Facebook! \(accessToken)")
                    
                    // Talk to Firebase
                    DataService.ds.REF_BASE.authWithOAuthProvider("facebook", token: accessToken, withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login Failed")
                        }
                        else {
                            print("Logged in! \(authData)")
                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID) // Save the value to the UID
                            self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                            
                        }
                    })
                    
                }
                
        })
    
    }
    
    @IBAction func  attemptLogin(sender: UIButton!) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                if error != nil {
                    print(error.code)
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { (error, result) in
                            
                            // If there is an error
                            if error != nil {
                                self.showErrorAlert("Could not create account", msg: "Problem creating account")
                            }
                            // Create A User
                            else {
                                // Set a value and grab result which is a dict
                                NSUserDefaults.standardUserDefaults().setValue(result[KEY_UID], forKey: KEY_UID)
                                
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: nil)
                                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil) // This line logs us in
                                
                            }
                        })
                    } else {
                        self.showErrorAlert("Could not login", msg: "Please check your username or password")
                    }
                }
                else {
                    self.performSegueWithIdentifier(SEGUE_LOGGED_IN, sender: nil)
                }
            })
        }
        else {
            showErrorAlert("Email and Password Required", msg: "You must enter an email and a password")
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
        
        }
    }



