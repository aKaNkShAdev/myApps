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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var loginBtn : FBSDKLoginButton = FBSDKLoginButton()
        loginBtn.center = self.view.center
        self.view.addSubview(loginBtn)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

