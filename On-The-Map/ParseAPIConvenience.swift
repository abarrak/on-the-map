//
//  ParseAPIConvenience.swift
//  On-The-Map
//
//  Created by Abdullah on 1/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import UIKit

extension ParseAPIClient {
    
    // Mark: - Definitions
    
    typealias allStudentsInfoCompletionHandler =
        (_ success: Bool, _ studentsInfoList: [StudentInformation]?, _ errorString: String?) -> Void
    
    typealias studentInfoCompletionHandler =
        (_ success: Bool, _ studentInfo: StudentInformation?, _ errorString: String?) -> Void
    
    typealias studentWriteOpsCompletionHandler = (_ success: Bool, _ errorString: String?) -> Void
    
    // Mark: - High level methods
    
    func getAllStudentsInfo(completionHandler: @escaping allStudentsInfoCompletionHandler) {
        let parameters = [Constants.ParameterKeys.Order: "-updatedAt", Constants.ParameterKeys.Limit : "100"]
        
        let _ = genericParseTask(apiMethod: Constants.Methods.AllLocations, parameters: parameters as [String:AnyObject], httpMethod: "GET", jsonBody: nil) { (results, error) in
            
            // Did the request failed?
            if error != nil {
                completionHandler(false, nil, "Fetching students' info failed.")
                return
            }
            
            // Were there any error json response?
            if let error = results?[Constants.JSONResponseKeys.Error], let code = results?[Constants.JSONResponseKeys.Code] {
                completionHandler(false, nil, "Error (no. \(code)) occured. \(error)")
                return
            }
            
            // Extract the info list data and construct Foundation array.
            let results = results?[Constants.JSONResponseKeys.Results] as? [[String:AnyObject]]
            
            if results != nil {
                completionHandler(true,
                                  StudentInformation.informationFromResults(results!),
                                  nil)
            } else {
                completionHandler(false, nil, "Unexpected parsing error occured. \(error)")
            }
        }
    }
    
    func getStudentInfo(userKey: String, completionHandler: @escaping studentInfoCompletionHandler) {
        let parameters = [Constants.ParameterKeys.Where: "{\"\(Constants.ParameterKeys.UniqueKey)\": \"\(userKey)\"}"]
        
        let _ = genericParseTask(apiMethod: Constants.Methods.AllLocations, parameters: parameters as [String:AnyObject], httpMethod: "GET", jsonBody: nil) { (results, error) in
            
            // Did the request failed?
            if error != nil {
                completionHandler(false, nil, "Fetching student's info failed.")
                return
            }
            
            // Were there any error json response?
            if let error = results?[Constants.JSONResponseKeys.Error], let code = results?[Constants.JSONResponseKeys.Code] {
                completionHandler(false, nil, "Error (no. \(code)) occured. \(error)")
                return
            }
            
            // Extract the info dictionary data and construct Foundation object.
            let results = results?[Constants.JSONResponseKeys.Results] as? [[String:AnyObject]]
            
            if results != nil {
                if let count = results?.count, count > 0 {
                    completionHandler(true, StudentInformation(dictionary: (results?[0])!), nil)
                } else {
                    completionHandler(false, nil, "No Data for you on the map yet.")
                }
            } else {
                completionHandler(false, nil, "Unexpected parsing error occured. \(error)")
            }
        }
    }
    
    func addStudentInfo(studentInfo: StudentInformation,
                        completionHandler: @escaping studentWriteOpsCompletionHandler) {
        let body = studentLocationRequestPayload(studentInfo: studentInfo)
        
        let _ = genericParseTask(apiMethod: Constants.Methods.AllLocations, parameters: [:], httpMethod: "POST", jsonBody: body) { (results, error) in
            // Did the request failed?
            if error != nil {
                completionHandler(false, "Fetching student's info failed.")
                return
            }
            
            // Were there any error json response?
            if let error = results?[Constants.JSONResponseKeys.Error], let code = results?[Constants.JSONResponseKeys.Code] {
                completionHandler(false, "Error (no. \(code)) occured. \(error)")
                return
            }

            // Extract success indicator data.
            let createdAt = results?[Constants.JSONResponseKeys.CreatedAt] as? String
            let objectId = results?[Constants.JSONResponseKeys.ObjectId] as?  String
            if createdAt != nil && objectId != nil {
                completionHandler(true, nil)
            } else {
                completionHandler(false, "[PARSE] Unexpected parsing error occured. \(error)")
            }
            
        }
    }
    
    func updateStudentInfo(studentInfo: StudentInformation,
                           completionHandler: @escaping studentWriteOpsCompletionHandler) {
        let body = studentLocationRequestPayload(studentInfo: studentInfo)
        let updateMethod = "\(Constants.Methods.AllLocations)/\(studentInfo.objectId)"
        
        let _ = genericParseTask(apiMethod: updateMethod, parameters: [:], httpMethod: "PUT", jsonBody: body) { (results, error) in
            // Did the request failed?
            if error != nil {
                completionHandler(false, "Fetching student's info failed.")
                return
            }
            
            // Were there any error json response?
            if let error = results?[Constants.JSONResponseKeys.Error], let code = results?[Constants.JSONResponseKeys.Code] {
                completionHandler(false, "Error (no. \(code)) occured. \(error)")
                return
            }

            // Extract success indicator data
            let results = results?[Constants.JSONResponseKeys.UpdatedAt] as? String
            
            if results != nil {
                completionHandler(true, nil)
            } else {
                completionHandler(false, "Unexpected parsing error occured. \(error)")
            }
            
        }
    }
    
    // Mark: - Heplers
    
    private func studentLocationRequestPayload(studentInfo: StudentInformation) -> String {
        return  "{ \"uniqueKey\": \"\(studentInfo.uniqueKey!)\", \"firstName\": \"\(studentInfo.firstName!)\",  \"lastName\": \"\(studentInfo.lastName!)\", \"mapString\": \"\(studentInfo.mapString!)\", \"mediaURL\": \"\(studentInfo.mediaURL!)\", \"latitude\": \(studentInfo.latitude!), \"longitude\": \(studentInfo.longitude!)}"
    }
}
