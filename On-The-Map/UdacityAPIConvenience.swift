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
        
        let _ = taskForSession(httpMethod: "POST", jsonBody: body) { (results, error) in
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
                completionHandlerForSession(false, nil, nil, "Unexpected parsing error occured. \(error)")
                return
            }

            // Extract our auth strings.
            let sessionID = sessionDict?[JSONResponseKeys.Id] as? String
            let userID = accountDict?[JSONResponseKeys.Key] as? String
            
            if sessionID != nil && userID != nil {
                completionHandlerForSession(true, sessionID!, userID!, nil)
            } else {
                completionHandlerForSession(false, nil, nil, "Unexpected parsing error occured. \(error)")
            }
        }
    }
  
    func logout(completionHandlerForSession: @escaping (_ success: Bool, _ errorString: String?) -> Void) {

        let _ = taskForSession(httpMethod: "DELETE", jsonBody: nil, addCsrf: true) { (results, error) in
            if error != nil {
                completionHandlerForSession(false, "Logout Failed. \(error)")
                return
            }
            
            // Were there any 4xx errors ?
            if let error = results?[JSONResponseKeys.Error] {
                completionHandlerForSession(false, "Logout failed. \(error)")
                return
            }
            
            // Extract json top level keys.
            let sessionDict = results?[JSONResponseKeys.Session] as? [String:Any?]
            
            if sessionDict == nil {
                completionHandlerForSession(false, "Unexpected parsing error occured. \(error)")
                return
            }
            
            // Extract our auth string.
            let sessionID = sessionDict?[JSONResponseKeys.Id] as? String
            
            if sessionID != nil {
                completionHandlerForSession(true, nil)
            } else {
                completionHandlerForSession(false,"Unexpected parsing error occured. \(error)")
            }
        }
    }
    
    
    func getProfile(userKey: String, completionHandler: @escaping (_ success: Bool, _ firstName: String?, _ lastName: String?, _ errorString: String?) -> Void) {
        
        let _ = taskForRetrieval(userKey: userKey) { (results, error) in
            if error != nil {
                completionHandler(false, nil, nil, "Fetching user info failed.")
                return
            }
            
            // Were there any 4xx errors ?
            if let error = results?[JSONResponseKeys.Error] {
                completionHandler(false, nil, nil, "Encountered error while fetching user date: \(error).")
                return
            }
            
            // Extract json top level keys.
            let userDict = results?[JSONResponseKeys.User] as? [String:Any?]
            
            if userDict == nil {
                completionHandler(false, nil, nil, "Unexpected parsing error occured. \(error)")
                return
            }
            
            // Extract lovely names ..
            let firstName = userDict?[JSONResponseKeys.FirstName] as? String
            let lastName = userDict?[JSONResponseKeys.LastName] as? String
            
            if firstName != nil && lastName != nil {
                completionHandler(true, firstName, lastName, nil)
            } else {
                completionHandler(false, nil, nil, "Unexpected parsing error occured. \(error)")
            }
        }

    }
    
    private func loginRequestBody(username: String, password: String) -> String {
        return "{\"\(ParameterKeys.Udacity)\": {\"\(ParameterKeys.Username)\": \"\(username)\", \"\(ParameterKeys.Password)\": \"\(password)\"}}"
    }
}
