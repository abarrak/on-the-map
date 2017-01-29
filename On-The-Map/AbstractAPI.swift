//
//  AbstractAPI.swift
//  On-The-Map
//
//  Created by Abdullah on 1/28/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

class AbstractAPI: NSObject {
    // Mark: - Type definitions
    
    // Define a generic completion handler closure for api tasks.
    typealias handlerType = (_ result: [String:Any]?, _ error: NSError?) -> Void
}
