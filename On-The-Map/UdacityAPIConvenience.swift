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
    
    // Mark: - Definitions
    
    typealias getProfileCompletionHandler =
        (_ success: Bool, _ firstName: String?, _ lastName: String?, _ errorString: String?) -> Void
    
    typealias loginCompletionHandler =
        (_ success: Bool, _ sessionID: String?, _ userID: String?, _ errorString: String?) -> Void

    typealias logoutCompletionHandler = (_ success: Bool, _ errorString: String?) -> Void
    
    
    // Mark: - High level methods
    
    func login(username: String, password: String,
               completionHandlerForSession: @escaping loginCompletionHandler) {
        
        let body = loginRequestBody(username: username.trim(), password: password.trim())
        
        let _ = taskForSession(httpMethod: "POST", jsonBody: body) { (results, error) in
            if error != nil {
                completionHandlerForSession(false, nil, nil, "Login Failed: \(error!.localizedDescription)")
                return
            }
                
            // Were there any 4xx errors or others ?
            if let error = results?[Constants.JSONResponseKeys.Error] {
                completionHandlerForSession(false, nil, nil, "Login failed. \(error)")
                return
            }
            
            // Extract json top level keys.
            let sessionDict = results?[Constants.JSONResponseKeys.Session] as? [String:Any?]
            let accountDict = results?[Constants.JSONResponseKeys.Account] as? [String:Any?]
            
            if sessionDict == nil || accountDict == nil {
                completionHandlerForSession(false, nil, nil, "Unexpected parsing error occured. \(error)")
                return
            }

            // Extract our auth strings.
            let sessionID = sessionDict?[Constants.JSONResponseKeys.Id] as? String
            let userID = accountDict?[Constants.JSONResponseKeys.Key] as? String
            
            if sessionID != nil && userID != nil {
                completionHandlerForSession(true, sessionID!, userID!, nil)
            } else {
                completionHandlerForSession(false, nil, nil, "Unexpected parsing error occured. \(error)")
            }
        }
    }
  
    func logout(completionHandlerForSession: @escaping logoutCompletionHandler) {

        let _ = taskForSession(httpMethod: "DELETE", jsonBody: nil, addCsrf: true) { (results, error) in
            if error != nil {
                completionHandlerForSession(false, "Logout Failed. \(error!.localizedDescription)")
                return
            }
            
            // Were there any 4xx errors ?
            if let error = results?[Constants.JSONResponseKeys.Error] {
                completionHandlerForSession(false, "Logout failed. \(error)")
                return
            }
            
            // Extract json top level keys.
            let sessionDict = results?[Constants.JSONResponseKeys.Session] as? [String:Any?]
            
            if sessionDict == nil {
                completionHandlerForSession(false, "Unexpected parsing error occured. \(error)")
                return
            }
            
            // Extract our auth string.
            let sessionID = sessionDict?[Constants.JSONResponseKeys.Id] as? String
            
            if sessionID != nil {
                completionHandlerForSession(true, nil)
            } else {
                completionHandlerForSession(false,"Unexpected parsing error occured. \(error)")
            }
        }
    }
    
    
    func getProfile(userKey: String, completionHandler: @escaping getProfileCompletionHandler) {
        let _ = taskForRetrieval(userKey: userKey) { (results, error) in
            if error != nil {
                completionHandler(false, nil, nil, "Fetching user info failed.")
                return
            }
            
            // Were there any 4xx errors ?
            if let error = results?[Constants.JSONResponseKeys.Error] {
                completionHandler(false, nil, nil, "Error encountered while fetching user date: \(error).")
                return
            }
            
            // Extract json top level keys.
            let userDict = results?[Constants.JSONResponseKeys.User] as? [String:Any?]
            
            if userDict == nil {
                completionHandler(false, nil, nil, "[Udacity] Unexpected parsing error occured. \(error)")
                return
            }
            
            // Extract lovely names ..
            let firstName = userDict?[Constants.JSONResponseKeys.FirstName] as? String
            let lastName = userDict?[Constants.JSONResponseKeys.LastName] as? String
            let nickname = userDict?[Constants.JSONResponseKeys.Nickname] as? String
            
            if firstName != nil && lastName != nil {
                completionHandler(true, firstName, lastName, nil)
            } else {
                
                // Humm ~ New udacity api does not return your first and last name even if they 
                // are set in Postman, but in iOS sim. they came magically ! 
                // nick name is just an ensurance.
                if nickname != nil {
                    completionHandler(true, nickname, nickname, nil)
                } else {
                    completionHandler(false, nil, nil, "Unexpected parsing error occured. \(error)")
                }
            }
        }
    }
    
    // Mark: - Helpers
    
    private func loginRequestBody(username: String, password: String) -> String {
        return "{\"\(Constants.ParameterKeys.Udacity)\": {\"\(Constants.ParameterKeys.Username)\": \"\(username)\", \"\(Constants.ParameterKeys.Password)\": \"\(password)\"}}"
    }
}
