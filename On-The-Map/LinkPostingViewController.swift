//
//  LinkPostingViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 2/3/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import MapKit

class LinkPostingViewController: UIViewController, UITextFieldDelegate {

    // Mark: - Properties

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var linkShareText: UITextField!
    @IBOutlet weak var pinMap: MKMapView!
    @IBOutlet weak var submitButton: UIButton!

    var linkShareTextPlaceholder: String {
        get {
            return "Enter a link to share here"
        }
    }
    
    var currentStudentInfo: StudentInformation?

    // Mark: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        linkShareText.delegate = self
    }
    
    // Mark: - Actions

    
    @IBAction func cancel(_ sender: UIButton) {
        discard()
    }
    
    @IBAction func submit(_ sender: UIButton) {
        // Skip if link text is empty.
        if (linkShareText.text?.isBlank())! {
            return
        }
        
        if isLinkValid(link: linkShareText.text) {
            sendNewPinInfo()
            discard()
        } else {
            alertMessage("Invalid URL", message: "Please type in a valid link address.")
        }
    }
 
    // Mark: - Methods

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if linkShareText.text! == linkShareTextPlaceholder {
            linkShareText.text = ""
        }
    }
    
    func discard() {
        self.presentingViewController!.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    private func sendNewPinInfo() {
        if currentStudentInfo == nil {
            addPin()
        } else {
            updatePin()
        }
    }
    
    // Mark: - Helpers
    
    private func isLinkValid(link: String?) -> Bool {
        if let urlString = link {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }

    private func addPin() {
        ParseAPIClient.sharedInstance().addStudentInfo(studentInfo: currentStudentInfo!) {
            (success, errorMsg) in
            if !success {
                performUIUpdatesOnMain({
                    self.alertMessage("Error", message: errorMsg!)
                })
            } else {
                performUIUpdatesOnMain({
                    self.alertMessage("Success", message: "You pin has been posted successfully !")
                })
            }
        }
    }
    
    private func updatePin() {
        ParseAPIClient.sharedInstance().updateStudentInfo(studentInfo: currentStudentInfo!) {
            (success, errorMsg) in
            if !success {
                performUIUpdatesOnMain({
                    self.alertMessage("Error", message: errorMsg!)
                })
            } else {
                performUIUpdatesOnMain({
                    self.alertMessage("Success", message: "You pin has been updated successfully !")
                })
            }
        }
    }
}
