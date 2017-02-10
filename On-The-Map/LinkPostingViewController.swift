//
//  LinkPostingViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 2/3/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

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
    
    var userKey: String? = nil
    var locationString: String? = nil
    
    var currentStudentInfo: StudentInformation?
    var geocodedLocation: CLLocationCoordinate2D?
    
    var firstName: String = ""
    var lastName: String = ""
    
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
            sendNewPinInfoThenDiscard()
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
    
    private func sendNewPinInfoThenDiscard() {
        currentStudentInfo == nil ? addPin() : updatePin()
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
        constructStudentInfoThenAddIt()
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
            performUIUpdatesOnMain({ self.discard() })
        }
    }
    
    private func constructStudentInfoThenAddIt() {

        // Grap the profile from Udacity ..
        UdacityAPIClient.sharedInstance().getProfile(userKey: userKey!) {
            (success, firstName, lastName, errorString) in
            if !success {
                performUIUpdatesOnMain({
                    self.alertMessage("Failed", message: errorString!)
                })
            } else {
                performUIUpdatesOnMain({
                    self.firstName = firstName!
                    self.lastName = lastName!
                    print(self.userKey!)
                    print(String(Float((self.geocodedLocation?.latitude)!)) + "Yeah")
                    print(String(Float((self.geocodedLocation?.latitude)!)) + "Yeah")
                    
                    // If data obtained successfully, build the object and post to Parse..
                    
                    let studentInfo = StudentInformation(uniqueKey: self.userKey,
                                                         firstName: self.firstName,
                                                         lastName: self.lastName,
                                                         mapString: self.locationString,
                                                         mediaURL: self.linkShareText.text!,
                                                         latitude: Float((self.geocodedLocation?.latitude)!),
                                                         longitude: Float((self.geocodedLocation?.latitude)!))

                    ParseAPIClient.sharedInstance().addStudentInfo(studentInfo: studentInfo) {
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
                        
                        performUIUpdatesOnMain({ self.discard() })
                    }
                })
            }
        }
    }
}
