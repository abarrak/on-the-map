//
//  UdacityAPIClient.swift
//  OnTheMap
//
//  Created by Abdullah on 12/2/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import Foundation
import UIKit

class UdacityAPIClient: AbstractAPI {
    
    // MARK: - Properties
    
    var session = URLSession.shared
    
    var sessionID: String? = nil
    var userID: Int? = nil
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: - Methods
    
     func taskForSession(httpMethod: String, jsonBody: String?, addCsrf: Bool = false,
                        completionHandler: @escaping handlerType) {
        
        // Exit properly if no connection available.
        if !isNetworkAvaliable() {
            notifyDisconnectivity(completionHandler)
            return
        }

        // Build the request from URL and configure it ..
        let apiMethod = "/\(Constants.Methods.Session)"
        
        var request = URLRequest(url: udacityApiURL(withPathExtension: apiMethod))
        request = configureAPIRequest(requestObj: request, method: httpMethod, body: jsonBody)
        
        if addCsrf {
            request = addCsrfToRequest(requestObj: request)
        }
        
        // Make the request ..
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            func reportError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "taskForSessionlogin", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                reportError("There was an error with the login process: \(error)")
                return
            }
            
            /* GUARD: Did we get a status code out of the api expected ones ? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 500 else {
                reportError("There was an unexpected error while attempting login. Try again.")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
                reportError("Data curruption from the server. Sorry for the inconvenience.")
                return
            }
            
            // Extact the raw data and pass it for parsing.
            let skipped = self.skipFiveCharsFromResponse(responseData: data)!
            self.convertDataWithCompletionHandler(skipped,
                                                  completionHandlerForConvertData: completionHandler)
        })
        
        // Start the request ..
        task.resume()
    }
    
    func taskForRetrieval(userKey: String, completionHandler: @escaping handlerType) {

        // Exit properly if no connection available.
        if !isNetworkAvaliable() {
            notifyDisconnectivity(completionHandler)
            return
        }

        // Build the request from URL and configure it ..
        let apiMethod = "/\(Constants.Methods.Users)/\(userKey)"
        
        var request = URLRequest(url: udacityApiURL(withPathExtension: apiMethod))
        request = configureAPIRequest(requestObj: request, method: "GET", body: nil)
        
        // Make the request ..
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            func reportError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "taskForSessionlogin", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                reportError("There was an error with the login process: \(error)")
                return
            }
            
            /* GUARD: Did we get a status code out of the api expected ones ? */
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode < 500 else {
                reportError("There was an unexpected error while attempting uesr profile read. Try again.")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
                reportError("Data curruption from the server. Sorry for the inconvenince")
                return
            }
            
            // Extact the raw data and pass it for parsing.
            let skipped = self.skipFiveCharsFromResponse(responseData: data)!
            self.convertDataWithCompletionHandler(skipped,
                                                  completionHandlerForConvertData: completionHandler)
        })
        
        // Start the request ..
        task.resume()
    }
    
    // MARK: - Helpers
    
    private func udacityApiURL(withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = UdacityAPIClient.Constants.ApiScheme
        components.host = UdacityAPIClient.Constants.ApiHost
        components.path = UdacityAPIClient.Constants.ApiPath + (withPathExtension ?? "") // C# memories ...
        // print(components.url!)
        return components.url!
    }
    
    private func configureAPIRequest(requestObj: URLRequest, method: String,
                                     body: String? = nil) -> URLRequest {
        var request = requestObj
        
        request.httpMethod = method
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            request.httpBody = body.data(using: String.Encoding.utf8)
        }
        
        return request
    }
    
    private func addCsrfToRequest(requestObj: URLRequest) -> URLRequest {
        var request = requestObj
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        return request
    }
    
    
    private func skipFiveCharsFromResponse(responseData: Data?) -> Data? {
        let range = Range(uncheckedBounds: (5, responseData!.count))
        return responseData?.subdata(in: range)
    }
    
    // Given raw JSON, return a usable Foundation object.
    private func convertDataWithCompletionHandler(_ data: Data,
                                                  completionHandlerForConvertData: handlerType) {
        var parsedResult: [String:Any]? = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data,
                                                            options: .allowFragments) as? [String:Any]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil, NSError(domain: "convertDataWithCompletionHandler",
                                                         code: 1,
                                                         userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // MARK: - Shared Instance
    
    class func sharedInstance() -> UdacityAPIClient {
        struct Singleton {
            static var sharedInstance = UdacityAPIClient()
        }
        return Singleton.sharedInstance
    }
}
