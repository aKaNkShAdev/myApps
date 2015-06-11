//
//  ViewController.swift
//  What to Wear Today
//
//  Created by Akanksha Sharma on 06/06/15.
//  Copyright (c) 2015 akanksha. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
//import FBSDKGraphRequest

class ViewController: UIViewController,FBSDKLoginButtonDelegate {

    @IBOutlet weak var userProfileImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var welcomeLabel: UILabel!

    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var fbloginBtn: UIButton!
    
    
    var dict : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(NSUserDefaults.standardUserDefaults().objectForKey("fbDetails") != nil){
            dict = NSUserDefaults.standardUserDefaults().objectForKey("fbDetails") as! NSDictionary
            self.userName.text = self.dict.objectForKey("name") as? String
            self.userProfileImg.image = getImageFromURL(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url")as! String)
            fbloginBtn.hidden = true
            userProfileImg.hidden = false
            userName.hidden = false
            nextBtn.hidden = false

            welcomeLabel.hidden = false
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func btnFBLoginPressed(sender: AnyObject) {
        var fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                var fbloginresult : FBSDKLoginManagerLoginResult = result
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.fetchUserData()
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
    
    /*!
    @abstract Sent to the delegate when the button was used to login.
    @param loginButton the sender
    @param result The results of the login
    @param error The error (if any) from the login
    */
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        println(result.token.description)
        println(FBSDKProfile.currentProfile())
        //var profile : NSDictionary = result as! NSDictionary
        //println(profile)
        if((FBSDKAccessToken.currentAccessToken()) != nil){
         println(FBSDKGraphRequest().tokenString)
            
        }
        fetchUserData()

    }
    
    /*!
    @abstract Sent to the delegate when the button was used to logout.
    @param loginButton The button that was clicked.
    */
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!){
        
    }
    
    func fetchUserData(){
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email,gender"]).startWithCompletionHandler({ (connection, result, error) -> Void in
            if (error == nil){
                self.dict = result as! NSDictionary
                println(result)
                println(self.dict)
                NSLog(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url")as! String)
                NSUserDefaults.standardUserDefaults().setObject(self.dict, forKey: "fbDetails")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.userName.text = self.dict.objectForKey("name") as? String
                self.userProfileImg.image = getImageFromURL(self.dict.objectForKey("picture")?.objectForKey("data")?.objectForKey("url")as! String)
                self.fbloginBtn.hidden = true
                self.userProfileImg.hidden = false
                self.userName.hidden = false
                self.welcomeLabel.hidden = false
                self.nextBtn.hidden = false

            }else {
                println(error)
 
            }
        })
    }


}

