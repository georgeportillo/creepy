//
//  SinglePartViewController.swift
//  swiftme
//
//  Created by George Portillo on 3/8/16.
//  Copyright © 2016 George. All rights reserved.
//

import UIKit
import GoogleMobileAds

import Bolts
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit

import Firebase

class SinglePartViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var singlePartData: Part!

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var singlePartTextView: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a reference to a Firebase location
        var myRootRef = Firebase(url:"https://engageio.firebaseio.com")
        // Write data to Firebase
        myRootRef.setValue("Do you have data? You'll love Firebase.")
        
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            // If not logged in, let user stay here
            print("Not loged in...")
        } else {
            // If logged in, segue to other view
            print("Loged in...")
        }
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["public_profile", "email", "user_friends"]
        loginButton.center = self.view.center
        loginButton.delegate = self
        self.view.addSubview(loginButton)
        
        bannerView.adUnitID = "ca-app-pub-8807766526289453/7977953619"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())

        self.automaticallyAdjustsScrollViewInsets = false
        
        singlePartTextView.text = singlePartData.title
        singlePartTextView.contentInset = UIEdgeInsetsMake(5.0,5.0,5,5.0)
        // Do any additional setup after loading the view.
    
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {

        print("User Logged In")

        if ((error) != nil) {
            // Process error
        } else if result.isCancelled {
            // Handle cancellations
        } else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email") {
                // Do work
                let pictureRequest = FBSDKGraphRequest(graphPath: "me/", parameters: nil)
                pictureRequest.startWithCompletionHandler({
                    (connection, result, error: NSError!) -> Void in
                    if error == nil {
                        print("\(result)")
                    } else {
                        print("\(error)")
                    }
                })
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
