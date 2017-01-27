//
//  RegistrationViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 1/21/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    // Mark: - Properties
    
    @IBOutlet weak var webView: UIWebView!
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        loadUdacitySignUpPage()
    }
    
    // Mark: - Methods
    
    private func loadUdacitySignUpPage() {
        let url = URL (string: "https://auth.udacity.com/sign-up?next=nil");
        let requestObj = URLRequest(url: url!);
        webView.loadRequest(requestObj);
    }
}
