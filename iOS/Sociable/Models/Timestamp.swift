//
//  Timestamp.swift
//  Sociable
//

import Foundation

public struct Timestamp: Hashable, Codable, Comparable {
    
    var _seconds = Int(NSDate().timeIntervalSince1970)
    var _nanoseconds = NSDate().timeIntervalSince1970 - Double(Int(NSDate().timeIntervalSince1970))
    
    func formattedToDate() -> NSDate {
        return NSDate(timeIntervalSince1970: Double(_seconds))
    }
    
    public static func < (lhs: Timestamp, rhs: Timestamp) -> Bool {
        if (lhs._seconds < rhs._seconds) {
            return true
        } else if (lhs._seconds == rhs._seconds) {
            return lhs._nanoseconds < rhs._nanoseconds
        }
        return false
    }
}
