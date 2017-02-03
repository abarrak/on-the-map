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
    
    var logoutButton: UIBarButtonItem? = nil
    var refershButton: UIBarButtonItem? = nil
    var pinButton: UIBarButtonItem? = nil
    
    var studentsInfoList: [StudentInformation]?
    var currentStudentInfo: StudentInformation?
    
    // Mark: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTopBar()
        fetchAllStudentsData()
        fetchCurrentStudentData()
    }
    
    // Mark: - Actions
    
    func logoutPressed() {
        setUIEnabled(false)
        
        UdacityAPIClient.sharedInstance().logout {
            (sucess, errorMsg) in
            
            if !sucess {
                performUIUpdatesOnMain({
                    super.alertMessage("Failure", message: errorMsg!)
                    self.setUIEnabled(true)
                })
                return
            }
            
            performUIUpdatesOnMain({
                self.setUIEnabled(true)
                self.sessionID = nil
                self.userKey = nil
                
                _ = self.navigationController?.popToRootViewController(animated: true)
                self.alertMessage("Success", message: "Logged out successfully.")
            })
        }
    }
    
    func refersh() {
        
    }
    
    func pin() {
        // TODO: alert if user already has a pin.
        performSegue(withIdentifier: "infoPosting", sender: self)
    }
    
    // Mark: - Methods
    
    private func setupTopBar() {
        logoutButton    = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.plain,
                                          target: self,
                                          action: #selector(logoutPressed))
        
        refershButton   = UIBarButtonItem(image: #imageLiteral(resourceName: "RefershIcon"), style: UIBarButtonItemStyle.plain,
                                          target: self, action: #selector(refersh))
        
        pinButton       = UIBarButtonItem(image: #imageLiteral(resourceName: "PinIcon"), style: UIBarButtonItemStyle.plain,
                                          target: self, action: #selector(pin))
        
        navigationItem.title = "On The Map"
        navigationItem.leftBarButtonItem = logoutButton
        navigationItem.rightBarButtonItems = [refershButton!, pinButton!]
    }
    
    private func setUIEnabled(_ enabled: Bool) {
        logoutButton?.isEnabled = enabled
    }
    
    private func fetchAllStudentsData() {
        ParseAPIClient.sharedInstance().getAllStudentsInfo { (success, studentsInfoList, errorMsg) in
            if !success {
                performUIUpdatesOnMain({
                    self.alertMessage("Failure", message: errorMsg!)
                })
                return
            }
                
            performUIUpdatesOnMain({
                self.studentsInfoList = studentsInfoList
            })
        }
    }
    
    private func fetchCurrentStudentData() {
        ParseAPIClient.sharedInstance().getStudentInfo(userKey: userKey!) { (success, studentInfo, errorMsg) in
            if !success {
                performUIUpdatesOnMain({
                    self.alertMessage("Failure", message: errorMsg!)
                })
                return
            }
            
            performUIUpdatesOnMain({
                self.currentStudentInfo = studentInfo
            })
        }
    }
    
    // Mark: - Helpers
}
