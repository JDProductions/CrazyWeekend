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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                            self.performSegueWithIdentifier("loggedIn", sender: nil)
                            
                        }
                    })
                    
                }
                
        })
    
    }
    



}

