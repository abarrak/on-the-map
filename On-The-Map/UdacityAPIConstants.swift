//
//  UdacityAPIConstants.swift
//  OnTheMap
//
//  Created by Abdullah on 12/2/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import Foundation

extension UdacityAPIClient {
    // MARK: API URL and keys.
    
    struct Constants {
        // API URL segments
        static let ApiScheme = "https"
        static let ApiHost = "www.udacity.com"
        static let ApiPath = "/api"
        
        // MARK: API HTTP Method
        struct Methods {
            static let Session = "session"
            static let Users = "users"
        }
        
        // MARK: Parameter Keys
        struct ParameterKeys {
            static let Udacity = "udacity"
            static let Username = "username"
            static let Password = "password"
        }
        
        
        // MARK: JSON Response Keys
        struct JSONResponseKeys {
            // 'account' is dictionary root key that contains two piece of info: registered, and user key.
            static let Account = "account"
            static let Registered = "registered"
            static let Key = "key"
            
            // 'session' is dictionary root key that contains two piece of info: session id, and expiration.
            static let Session = "session"
            static let Id = "id"
            static let Expiration = "expiration"
            
            // In error cases.
            static let Error = "error"
            static let Status = "status"
            
            // 'user' is dictionary root key that cotains the user's udacity profile. Rest are childern keys for it.
            static let User = "user"
            static let FirstName = "first_name"
            static let LastName = "last_name"
            static let Nickname = "nickname"
        }
    }
}
