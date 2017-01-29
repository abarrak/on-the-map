//
//  StudentsTableViewController.swift
//  On-The-Map
//
//  Created by Abdullah on 1/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class StudentsTableViewController: UITableViewController {
    
    // Mark: - Properties
    
    var studentsInfo: [StudentInformation]? {
        return (self.tabBarController as! MapTabBarController).studentsInfoList ?? nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentsInfo?.count ?? 0
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentsInfoCell",
                                                 for: indexPath)
        
        let studentInfo = studentsInfo?[indexPath.row]
        cell.textLabel?.text = studentInfo?.fullName

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
