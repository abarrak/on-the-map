//
//  ParseAPIConstants.swift
//  OnTheMap
//
//  Created by Abdullah on 11/30/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import Foundation

extension ParseAPIClient {
    
    struct Constants {
        // MARK: - API URL and keys.

        // App Id and REST API Key
        static let AppID  = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let ApiKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        
        // API URL segments
        static let ApiScheme = "https"
        static let ApiHost = "parse.udacity.com"
        static let ApiPath = "/parse/classes"
        
        // MARK: API HTTP Method
        struct Methods {
            // Query a single location, all, alter, or create new one by StudentLocation GET/POST/PUT.
            static let AllLocations = "/StudentLocation"
        }
        
        // MARK: - Parameter Keys
        
        struct ParameterKeys {
            static let AppID = "X-Parse-Application-Id"
            static let ApiKey = "X-Parse-REST-API-Key"

            // Manily fro StudentLocation POST/PUT params.
            static let ContentType = "Content-Type"
            static let Accept = "Accept"
            
            // StudentLocation Get method params. for all list.
            static let Limit = "limit"
            static let Skip = "skip"
            static let Order = "order"
            
            // StudentLocation Get method params. for single record only.
            static let Where = "where"
            static let UniqueKey = "uniqueKey"
            
            // StudentLocation PUT params.
            static let ObjectId = "objectId"
        }
        
        
        // MARK: - JSON Response Keys
        
        struct JSONResponseKeys {
            // Top level key.
            static let Results = "results"
            
            // All for GET responses.
            // In POST we have 'createdAt' & 'updatedAt'.
            // In PUST, only 'updatedAt'.
            static let TopLevelKey = "results"
            static let ObjectId = "objectId"
            static let UniqueKey = "uniqueKey"
            static let FirstName = "firstName"
            static let LastName = "lastName"
            static let MapString = "mapString"
            static let MediaURL = "mediaURL"
            static let Latitude = "latitude"
            static let Longitude = "longitude"
            static let CreatedAt = "createdAt"
            static let UpdatedAt = "updatedAt"
            
            // Errors
            static let Error = "error"
            static let Code = "code"
        }
    }
}
