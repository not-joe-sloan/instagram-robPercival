//
//  ViewController.swift
//  Instagram
//
//  Created by Joe Sloan on 11/29/17.
//  Copyright © 2017 Joe Sloan. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    //Variable to keep track of signup mode
    var signupModeActive = true
    
    func displayAlert(title: String, message: String){
        //Create an alert called "Error in Form" with a subtitle.  Normal Styling.
        let alert = UIAlertController(title: title as String, message: message as String, preferredStyle: UIAlertControllerStyle.alert)
        
        //Add an action to the alert for the user to dismiss it.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        //Present the alert, don't do anything when it's dismissed.
        self.present(alert, animated: true, completion: nil)
    }
    

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passField: UITextField!
    @IBOutlet weak var signupOrLoginButton: UIButton!
    @IBOutlet weak var switchLoginModeButton: UIButton!
    @IBAction func signupOrLogin(_ sender: Any) {
        
        if emailField.text == "" || passField.text == "" {
            
            displayAlert(title: "Error in form", message: "Enter an email")
            
        }else{
            
            //Create an activityIndicator Variable
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
            
            //Set the activityIndicator in the center of the view
            activityIndicator.center = self.view.center
            
            //Hide the indicator when stopped
            activityIndicator.hidesWhenStopped = true
 
            //Set the style to gray
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            
            //Add the activity indicator to the view, start spinning it, and start ignoring interactions
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
    
            if (signupModeActive) {
                print("Signing up...")
                let user = PFUser()
                user.username = emailField.text
                user.password = passField.text
                user.email = emailField.text
                
                user.signUpInBackground(block: { (success, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    if let error = error {
                        
                        self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)
                        //let errorString = error.userInfo["error"] as? NSString
                        // Show the errorString somewhere and let the user try again.
                        print(error)
                        
                    } else {
                        // Hooray! Let them use the app now.
                        print("Signed Up")
                    }
                })

            }else{
                PFUser.logInWithUsername(inBackground: emailField.text!, password: passField.text!, block: { (user, error) in
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    if user != nil{
                        print("Login Successful!")
                    }else{
                        
                        var errorText = "Unknown error, please try again"
                        
                        if error != nil {
                            errorText = (error?.localizedDescription)!
                        }
                        
                        self.displayAlert(title: "Couldn't sign in", message: errorText)
                    }
                })
            }
            
        }
        
    }
    @IBAction func switchLoginMode(_ sender: Any) {
        
        if (signupModeActive) {
            signupModeActive = false
            signupOrLoginButton.setTitle("Log In", for: [])
            switchLoginModeButton.setTitle("Sign Up", for: [])
        }else{
            signupModeActive = true
            signupOrLoginButton.setTitle("Sign Up", for: [])
            switchLoginModeButton.setTitle("Log In", for: [])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

