//
//  StringExtension.swift
//  On-The-Map
//
//  Created by Abdullah on 1/27/17.
//  Copyright © 2017 Abdullah Barrak. All rights reserved.
//

import Foundation

// God bless Ruby & Rails
extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func isBlank () -> Bool {
        return self.trim().isEmpty
    }

    // Convert a string to a proper formatted date type.
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter.date(from: self)
    }
}
