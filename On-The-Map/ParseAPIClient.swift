//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Abdullah on 11/30/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import Foundation

class ParseAPIClient : AbstractAPI {
    
    // MARK: - Properties
    
    var session = URLSession.shared
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: - Methods
    
    func genericParseTask(apiMethod: String, parameters: [String:AnyObject], httpMethod: String,
                          jsonBody: String?, completionHandler: @escaping handlerType) {
        
        // Exit properly if no connection available.
        if !isNetworkAvaliable() {
            notifyDisconnectivity(completionHandler)
            return
        }
        
        // Build the request from URL and configure it ..
        var request = URLRequest(url: parseURLFromParameters(parameters, withPathExtension: apiMethod))
        request = configureAPIRequest(requestObj: request, method: httpMethod, body: jsonBody)
        
        // Make the request ..
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            
            func reportError(_ error: String) {
                let userInfo = [NSLocalizedDescriptionKey : error]
                completionHandler(nil, NSError(domain: "taskForSessionlogin", code: 1, userInfo: userInfo))
            }
            
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                reportError("There was an error with the server connection: \(error)")
                return
            }
            
            /* GUARD: Did we get a status code out of the api expected ones ? */
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode! < 500 else {
                reportError("(\(statusCode!)) There was an unexpected error from the server. Try again.")
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard data != nil else {
                reportError("Data curruption from the server. Sorry for the inconvenience.")
                return
            }
            
            // Extact the raw data and pass it for parsing.
            self.convertDataWithCompletionHandler(data!, completionHandlerForConvertData: completionHandler)
        })
        
        // Start the request ..
        task.resume()
    }
    
    // MARK: - Helpers
    
    // create a URL from parameters
    private func parseURLFromParameters(_ parameters: [String:AnyObject],
                                        withPathExtension: String? = nil) -> URL {
        var components = URLComponents()
        components.scheme = Constants.ApiScheme
        components.host = Constants.ApiHost
        components.path = Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    private func configureAPIRequest(requestObj: URLRequest, method: String,
                                     body: String? = nil) -> URLRequest {
        var request = requestObj
        
        request.httpMethod = method
        
        request.addValue(Constants.AppID, forHTTPHeaderField: Constants.ParameterKeys.AppID)
        request.addValue(Constants.ApiKey, forHTTPHeaderField: Constants.ParameterKeys.ApiKey)
        request.addValue("application/json", forHTTPHeaderField: Constants.ParameterKeys.Accept)
        request.addValue("application/json", forHTTPHeaderField: Constants.ParameterKeys.ContentType)
        
        if let body = body {
            request.httpBody = body.data(using: String.Encoding.utf8)
        }
        
        return request
    }
    
    // Given raw JSON, return a usable Foundation object.
    private func convertDataWithCompletionHandler(_ data: Data,
                                                  completionHandlerForConvertData: handlerType) {
        var parsedResult: [String:Any]? = nil
        
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandlerForConvertData(nil,
                                            NSError(domain: "convertDataWithCompletionHandler",
                                                    code: 1,
                                                    userInfo: userInfo))
        }
        
        completionHandlerForConvertData(parsedResult, nil)
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseAPIClient {
        struct Singleton {
            static var sharedInstance = ParseAPIClient()
        }
        return Singleton.sharedInstance
    }
    
}
