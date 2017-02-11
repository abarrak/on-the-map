//
//  UrlValidator.swift
//  On-The-Map
//
//  Created by Abdullah on 2/11/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class UrlValidator {
    
    static func isLinkValid(link: String?) -> Bool {
        if let urlString = link {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }

}
