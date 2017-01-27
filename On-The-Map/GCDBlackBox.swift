//
//  GCDBlackBox.swift
//  OnTheMap
//
//  Created by Abdullah on 11/25/16.
//  Copyright © 2016 Abdullah. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
