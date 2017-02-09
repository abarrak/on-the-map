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

    // Mark: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        linkShareText.delegate = self
    }
    
    // Mark: - Actions

    
    @IBAction func cancel(_ sender: UIButton) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: UIButton) {
    }
    
    // Mark: - Methods

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if linkShareText.text! == linkShareTextPlaceholder {
            linkShareText.text = ""
        }
    }
    
}
