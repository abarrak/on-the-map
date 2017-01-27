//
//  ParseAPIClient.swift
//  OnTheMap
//
//  Created by Abdullah on 11/30/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import Foundation

class ParseAPIClient : NSObject {

    // MARK: - Properties
    
    var session = URLSession.shared
    
    // MARK: - Initializers
    
    override init() {
        super.init()
    }
    
    // MARK: - Methods
    
    // MARK: Helpers
    
    // substitute the key for the value that is contained within the method name
    func substituteKeyInMethod(_ method: String, key: String, value: String) -> String? {
        if method.range(of: "{\(key)}") != nil {
            return method.replacingOccurrences(of: "{\(key)}", with: value)
        } else {
            return nil
        }
    }
    
    // given raw JSON, return a usable Foundation object
    
    // create a URL from parameters
    private func parseURLFromParameters(_ parameters: [String:AnyObject], withPathExtension: String? = nil) -> URL {
        
        var components = URLComponents()
        components.scheme = ParseAPIClient.Constants.ApiScheme
        components.host = ParseAPIClient.Constants.ApiHost
        components.path = ParseAPIClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems!.append(queryItem)
        }
        
        return components.url!
    }
    
    // MARK: Shared Instance
    
    class func sharedInstance() -> ParseAPIClient {
        struct Singleton {
            static var sharedInstance = ParseAPIClient()
        }
        return Singleton.sharedInstance
    }

}
