//
//  MapTabBarController.swift
//  On-The-Map
//
//  Created by Abdullah on 1/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class MapTabBarController: UITabBarController {
    // Mark: - Properties
    
    var sessionID: String? = nil
    var userKey: String? = nil
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTopBar()
    }
    
    // Mark: - Methods
    
    func logoutPressed() {
        
    }
    
    func refersh() {
        
    }
    
    func pin() {
        
    }
    
    private func setupTopBar() {
        navigationItem.title = "On The Map"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout",
                                                           style: UIBarButtonItemStyle.plain,
                                                           target: self,
                                                           action: #selector(logoutPressed))
        
        let refershButton = UIBarButtonItem(image: #imageLiteral(resourceName: "RefershIcon"),
                                            style: UIBarButtonItemStyle.plain,
                                            target: self,
                                            action: #selector(refersh))
        
        let pinButton = UIBarButtonItem(image: #imageLiteral(resourceName: "PinIcon"),
                                        style: UIBarButtonItemStyle.plain,
                                        target: self,
                                        action: #selector(pin))
        
        navigationItem.rightBarButtonItems = [refershButton, pinButton]
    }
    
    // Mark: - Helpers
}
