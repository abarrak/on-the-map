//
//  UdacityAPIConvenience.swift
//  On-The-Map
//
//  Created by Abdullah on 1/26/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation
import UIKit

extension UdacityAPIClient {
    
    func login(username: String, password: String, completionHandlerForSession: @escaping (_ success: Bool, _ sessionID: String?, _ userID: String?, _ errorString: String?) -> Void) {
        
        let body = loginRequestBody(username: username.trim(), password: password.trim())
        
        let _ = taskForSessionOperation(jsonBody: body) { (results, error) in
            if error != nil {
                completionHandlerForSession(false, nil, nil, "Login Failed (Request Error): \(error)")
                return
            }
                
            // Were there any 4xx errors ?
            if let error = results?[JSONResponseKeys.Error] {
                completionHandlerForSession(false, nil, nil, "Login failed. \(error)")
                return
            }
            
            // Extract json top level keys.
            let sessionDict = results?[JSONResponseKeys.Session] as? [String:Any?]
            let accountDict = results?[JSONResponseKeys.Account] as? [String:Any?]
            
            if sessionDict == nil || accountDict == nil {
                completionHandlerForSession(false, nil, nil, "Unexpected Error occured .. \(error)")
                return
            }

            // Extract our auth strings.
            let sessionID = sessionDict?[JSONResponseKeys.Id] as? String
            let userID = accountDict?[JSONResponseKeys.Key] as? String
            
            if sessionID != nil && userID != nil {
                completionHandlerForSession(true, sessionID!, userID!, nil)
            } else {
                completionHandlerForSession(false, nil, nil, "Unexpected Error occured .. \(error)")
            }
        }
    }
  
    func logout(completionHandlerForAuth: @escaping (_ success: Bool, _ errorString: String?) -> Void) {
        
    }
    
    
    private func loginRequestBody(username: String, password: String) -> String {
        return "{\"\(ParameterKeys.Udacity)\": {\"\(ParameterKeys.Username)\": \"\(username)\", \"\(ParameterKeys.Password)\": \"\(password)\"}}"
    }

}
