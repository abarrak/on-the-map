//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Abdullah on 11/30/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // - Mark: Properties
    
    // Parse auto-generated id which uniquely identifies a StudentLocation.
    let objectId: String
    
    // An extra (optional) key used to uniquely identify a StudentLocation.
    // Should be populated this value using your Udacity account id
    let uniqueKey: String

    let firstName: String
    let lastName: String

    // The location string used for geocoding the student location.
    let mapString: String
    
    // The URL provided by the student.
    let mediaURL: String
    
    // The latitude of the student location (ranges from -90 to 90).
    let latitude: Float
    
    // The longitude of the student location (ranges from -180 to 180).
    let longitude: Float

    let createdAt: Date
    let updatedAt: Date
    
    // Parse access and control list (ACL), i.e. permissions, for this StudentLocation entry.
    //   let ACL: PFACL

    // - Mark: Initializers

    init(dictionary: [String : AnyObject]) {
        objectId    = dictionary[ParseAPIClient.JSONResponseKeys.ObjectId]  as! String
        uniqueKey   = dictionary[ParseAPIClient.JSONResponseKeys.UniqueKey] as! String
        firstName   = dictionary[ParseAPIClient.JSONResponseKeys.FirstName] as! String
        lastName    = dictionary[ParseAPIClient.JSONResponseKeys.LastName]  as! String
        mapString   = dictionary[ParseAPIClient.JSONResponseKeys.MapString] as! String
        mediaURL    = dictionary[ParseAPIClient.JSONResponseKeys.MediaURL]  as! String
        latitude    = dictionary[ParseAPIClient.JSONResponseKeys.Latitude]  as! Float
        longitude   = dictionary[ParseAPIClient.JSONResponseKeys.Longitude] as! Float
        createdAt   = dictionary[ParseAPIClient.JSONResponseKeys.CreatedAt] as! Date
        updatedAt   = dictionary[ParseAPIClient.JSONResponseKeys.UpdatedAt] as! Date
    }
    
    // - Mark: Methods

    static func informationFromResults(_ results: [[String : AnyObject]]) -> [StudentInformation] {
        var information = [StudentInformation]()
        
        for r in results {
            information.append(StudentInformation(dictionary: r))
        }
        
        return information
    }
}

// MARK: - StudentInformation: Equatable

extension StudentInformation: Equatable {}

func ==(lhs: StudentInformation, rhs: StudentInformation) -> Bool {
    return lhs.uniqueKey == rhs.uniqueKey
}
