//
//  LoginViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 1/21/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    // Mark: - Properties
    
    var authID = ""
    var authKey = ""
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    // Mark: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        self.navigationController?.isNavigationBarHidden = true
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.isNavigationBarHidden = false
        unsubscribeFromKeyboardNotifications()
    }
    
    // Mark: - Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    private func setUIEnabled(_ enabled: Bool) {
        loginButton.isEnabled = enabled
        
        // adjust login button alpha
        if enabled {
            loginButton.alpha = 1.0
        } else {
            loginButton.alpha = 0.5
        }
    }

    // Mark: Resolve Keyboard/UI issue
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillShow(_:)),
                                               name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(LoginViewController.keyboardWillHide(_:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillShow,
                                                  object: nil)
        
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name.UIKeyboardWillHide,
                                                  object: nil)
    }
    
    func keyboardWillShow(_ notification: Notification) {
        // TODO: Use scrollView, or other more robust mechanism.
        // Helpful -> http://stackoverflow.com/q/28813339
        if passwordText.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    // Mark: - Actions
    
    @IBAction func presentSignUpPage(_ sender: AnyObject) {
        performSegue(withIdentifier: "showSignUpView", sender: self)
    }

    private func presentMapViews() {
        performSegue(withIdentifier: "showMapViews", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMapViews" {
            let mapController = segue.destination as! MapTabBarController
            mapController.sessionID = authID
            mapController.userKey = authKey
        }
    }
    
    @IBAction func loginPressed(_ sender: AnyObject) {
        if isUserCredentialBlank() {
            return
        }
        
        setUIEnabled(false)
        
        UdacityAPIClient.sharedInstance().login(username: emailText.text!, password: passwordText.text!) {
            (sucess, sessionID, userID, errorMsg) in
            
            if !sucess {
                performUIUpdatesOnMain({
                    self.alertMessage("Failure", message: errorMsg!)
                    self.setUIEnabled(true)
                })
                return
            }
            
            performUIUpdatesOnMain({
                // self.alertMessage("Success", message: "\(sessionID) === \(userID)")
                self.setUIEnabled(true)

                self.authID = sessionID!
                self.authKey = userID!
                
                self.presentMapViews()
            })
        }
    }
    
    private func isUserCredentialBlank() -> Bool {
        return (emailText.text?.isBlank())! || (passwordText.text?.isBlank())! ? true : false
    }
    
    // Mark: - Helpers
    
    private func stylizeTextField(_ textField: UITextField) {
        // Some styling.
        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.black,
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 20)!,
        ]
        textField.defaultTextAttributes = memeTextAttributes
        
        // Position in the center.
        textField.textAlignment = NSTextAlignment.center
        
        // Make background transparent.
        textField.backgroundColor = UIColor.clear
    }    
}
