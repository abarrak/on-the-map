//
//  InfoPostingViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 2/3/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class InfoPostingViewController: UIViewController {

    // Mark: - Properties

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var locationText: UITextField!
    @IBOutlet weak var findButton: UIButton!

    // Mark: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Mark: - Actions

    @IBAction func cancel(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findOnMap(_ sender: UIButton) {
        performSegue(withIdentifier: "linkPosting", sender: self)
    }
    
    // Mark: - Methods
}
