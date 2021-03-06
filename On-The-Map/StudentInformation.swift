//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Abdullah on 11/30/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import Foundation

struct StudentInformation {
    
    // Mark: - Properties
    
    // Parse auto-generated id which uniquely identifies a StudentLocation.
    var objectId: String
    
    // An extra (optional) key used to uniquely identify a StudentLocation.
    // Should be populated this value using your Udacity account id
    var uniqueKey: String?

    var firstName: String?
    var lastName: String?

    // The location string used for geocoding the student location.
    var mapString: String?
    
    // The URL provided by the student.
    var mediaURL: String?
    
    // The latitude of the student location (ranges from -90 to 90).
    var latitude: Float?
    // The longitude of the student location (ranges from -180 to 180).
    var longitude: Float?

    var createdAt: Date?
    var updatedAt: Date?
    
    var fullName: String {
        if let firstName = firstName, let lastName = lastName {
            return firstName + " " + lastName
        }
        return "None"
    }
    
    // Parse access and control list (ACL), i.e. permissions, for this StudentLocation entry.
    //   let ACL: PFACL

    // Mark: - Initializers
    
    init(uniqueKey: String?, firstName: String?, lastName: String?, mapString: String?, mediaURL: String?, latitude: Float?, longitude: Float?) {
        self.objectId = ""
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = nil
        self.updatedAt = nil
    }
    
    init(dictionary: [String : AnyObject]) {
        objectId    = dictionary[ParseAPIClient.Constants.JSONResponseKeys.ObjectId]  as! String
        uniqueKey   = dictionary[ParseAPIClient.Constants.JSONResponseKeys.UniqueKey] as? String
        firstName   = dictionary[ParseAPIClient.Constants.JSONResponseKeys.FirstName] as? String
        lastName    = dictionary[ParseAPIClient.Constants.JSONResponseKeys.LastName]  as? String
        mapString   = dictionary[ParseAPIClient.Constants.JSONResponseKeys.MapString] as? String
        mediaURL    = dictionary[ParseAPIClient.Constants.JSONResponseKeys.MediaURL]  as? String
        latitude    = dictionary[ParseAPIClient.Constants.JSONResponseKeys.Latitude]  as? Float
        longitude   = dictionary[ParseAPIClient.Constants.JSONResponseKeys.Longitude] as? Float
        createdAt   = (dictionary[ParseAPIClient.Constants.JSONResponseKeys.CreatedAt] as! String).toDate()
        updatedAt   = (dictionary[ParseAPIClient.Constants.JSONResponseKeys.UpdatedAt] as! String).toDate()
    }
    
    // Mark: - Methods

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
