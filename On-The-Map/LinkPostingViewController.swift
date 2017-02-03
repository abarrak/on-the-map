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
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var linkShareText: UITextField!
    @IBOutlet weak var pinMap: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        self.presentingViewController!.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: UIButton) {
    }
}
