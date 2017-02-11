//
//  InfoPostingViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 2/3/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import CoreLocation

class InfoPostingViewController: UIViewController, UITextFieldDelegate {

    // Mark: - Properties

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var findButton: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var locationTextPlaceholder: String {
        get {
            return "Enter your location here"
        }
    }
    
    var userKey: String? = nil
    
    var currentStudentInfo: StudentInformation?
    var geocodedLocation: CLLocationCoordinate2D?
    
    // Mark: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationText.delegate = self
    }

    // Mark: - Actions and Protocol

    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findOnMap(_ sender: UIButton) {
        // Skip if location text is empty.
        if (locationText.text?.isBlank())! || locationText.text! == locationTextPlaceholder {
            return
        }
        setUIEnabled(false)
        geocodeThenProceed()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "linkPosting" {
            let linkPostingVC = segue.destination as! LinkPostingViewController
            linkPostingVC.currentStudentInfo = currentStudentInfo
            linkPostingVC.geocodedLocation = geocodedLocation
            linkPostingVC.userKey = userKey
            linkPostingVC.locationString = locationText.text!
        }
    }
    
    // Dissmiss keyboard once enter is pressed
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if locationText.text! == locationTextPlaceholder {
            locationText.text = ""
        }
    }

    // Mark: - Methods
    

    private func geocodeThenProceed() {
        let geocoder = CLGeocoder()
        
        geocoder.geocodeAddressString(locationText.text!) { (placemarks, error) in
            if error != nil {
                // self.alertMessage("Error", message: error.localizedDescription)
                self.alertMessage("Not Found", message: "Your location could not be found on the map.")
            }
            
            if let placemark = placemarks?.first {
                self.geocodedLocation = placemark.location!.coordinate
                self.performSegue(withIdentifier: "linkPosting", sender: self)
            }
            performUIUpdatesOnMain { self.setUIEnabled(true) }
        }
    }

    func setUIEnabled(_ enabled: Bool) {
        spinner.isHidden = !enabled
        findButton.isEnabled = enabled
    }
}
