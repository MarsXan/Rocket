//
//  LockType.swift
//  Rocket-iOS17
//
//  Created by mohsen mokhtari on 11/6/23.
//

import Foundation

enum LockType: String {
    case biometric = "Bio Metric Auth"
    case number = "Custom Number Lock"
    case both = "First preference will be biometric, and if it's not available, it will go for number lock."
    
}
