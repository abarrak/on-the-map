//
//  InfoPostingViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 2/3/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class InfoPostingViewController: UIViewController, UITextFieldDelegate {

    // Mark: - Properties

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var findButton: UIButton!
    
    var locationTextPlaceholder: String {
        get {
            return "Enter your location here"
        }
    }
    
    var currentStudentInfo: StudentInformation?
    
    // Mark: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationText.delegate = self
    }
    // Mark: - Actions

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findOnMap(_ sender: UIButton) {
        // Skip if location text is empty.
        if (locationText.text?.isBlank())! {
            return
        }
        
        if isLocationFound() {
            performSegue(withIdentifier: "linkPosting", sender: self)
        } else {
            alertMessage("Not Found", message: "Your location could not be found on the map.")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "linkPosting" {
            let linkPostingVC = segue.destination as! LinkPostingViewController
            linkPostingVC.currentStudentInfo = currentStudentInfo
        }
    }
    
    // Mark: - Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if locationText.text! == locationTextPlaceholder {
            locationText.text = ""
        }
    }
    
    private func isLocationFound() -> Bool {
        return true
    }
    
    private func geocodeLocation() {
    }
}
