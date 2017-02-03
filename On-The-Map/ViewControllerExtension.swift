//
//  ViewControllerExtension.swift
//  On-The-Map
//
//  Created by Abdullah on 1/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

extension UIViewController {
    func alertMessage(_ title: String, message: String) {
        let alert = UIAlertController(title: title,message: message,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "ok", style: UIAlertActionStyle.default) {
            action in self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}
