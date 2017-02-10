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
        zoomToLocation()
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
        presentingViewController!.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    private func sendNewPinInfoThenDiscard() {
        setUIEnabled(false)
        currentStudentInfo == nil ? addPin() : updatePin()
    }
    
    private func addPin() {
        constructStudentInfoThenAddIt()
    }
    
    private func updatePin() {
        // Reflect new changes ..
        currentStudentInfo?.mediaURL = linkShareText?.text
        currentStudentInfo?.latitude = Float((self.geocodedLocation?.latitude)!)
        currentStudentInfo?.longitude = Float((self.geocodedLocation?.longitude)!)
        currentStudentInfo?.mapString =  locationString
        
        // Communicate them with Parse ..
        ParseAPIClient.sharedInstance().updateStudentInfo(studentInfo: currentStudentInfo!) {
            (success, errorMsg) in
            if !success {
                performUIUpdatesOnMain({
                    self.alertThenExit("Error", message: errorMsg!)
                })
            } else {
                performUIUpdatesOnMain({
                    self.alertThenExit("Success", message: "You pin has been updated successfully !")
                })
            }
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

                    // If data obtained successfully, build the object and post to Parse..
                    
                    let studentInfo = StudentInformation(uniqueKey: self.userKey,
                                                         firstName: self.firstName,
                                                         lastName: self.lastName,
                                                         mapString: self.locationString,
                                                         mediaURL: self.linkShareText.text!,
                                                         latitude: Float((self.geocodedLocation?.latitude)!),
                                                         longitude: Float((self.geocodedLocation?.longitude)!))

                    ParseAPIClient.sharedInstance().addStudentInfo(studentInfo: studentInfo) {
                        (success, errorMsg) in
                        if !success {
                            performUIUpdatesOnMain({
                                self.alertThenExit("Error", message: errorMsg!)
                            })
                            
                        } else {
                            performUIUpdatesOnMain({
                                self.alertThenExit("Success", message: "You pin has been posted successfully !")
                                                 
                            })
                        }
                    }
                })
            }
        }
    }
    
    func zoomToLocation() {
        let lat = geocodedLocation?.latitude
        let long = geocodedLocation?.longitude
        
        let latDelta: CLLocationDegrees = 0.05
        let longDelta: CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpanMake(latDelta, longDelta)
        let location = CLLocationCoordinate2DMake(lat!, long!)
        let region = MKCoordinateRegionMake(location, span)
        
        pinMap.setRegion(region, animated: true)
    }

    // Mark: - Helpers
    
    func setUIEnabled(_ enabled: Bool) {
        submitButton.isEnabled = enabled
    }
    
    private func isLinkValid(link: String?) -> Bool {
        if let urlString = link {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    func alertThenExit(_ title: String, message: String) {
        setUIEnabled(true)
        alertMessage(title, message: message, completionHandler: { (action) in self.discard() })
    }
}
