//
//  LinkPostingViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 2/3/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit
import MapKit

class LinkPostingViewController: UIViewController {

    // Mark: - Properties

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var linkShareText: UITextField!
    @IBOutlet weak var pinMap: MKMapView!
    @IBOutlet weak var submitButton: UIButton!

    // Mark: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Mark: - Actions

    
    @IBAction func cancel(_ sender: UIButton) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: UIButton) {
    }
    
    // Mark: - Methods
}
