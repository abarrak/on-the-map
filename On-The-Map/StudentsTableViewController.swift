//
//  StudentsTableViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 1/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class StudentsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Mark: - Properties

    @IBOutlet weak var tableView: UITableView!
    
    var studentsInfo: [StudentInformation]? {
        return (self.tabBarController as! MapTabBarController).studentsInfoList ?? nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsInfo?.count ?? 0
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsInfoCell",
                                                 for: indexPath)
        
        let studentInfo = studentsInfo?[indexPath.row]
        cell.imageView?.image = UIImage(named: "PinIcon")
        cell.textLabel?.text = studentInfo?.fullName ?? "None"

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Navigate to selected student pin on the map.
        let mapVC = tabBarController?.childViewControllers[0] as! MapViewController
        mapVC.studentInfoToVisit = studentsInfo?[indexPath.row]
        
        tabBarController?.selectedIndex = 0
    }
}
