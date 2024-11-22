//
//  Date+.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/15/24.
//

import Foundation

extension Date {
    
    func formatTo(dateFormat: String = "yyyy-MM-dd, HH:mm") -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = dateFormat
        
        return formatter.string(from: self)
    }
    
    func toTimestamp() -> Int {
        return Int(self.timeIntervalSince1970)
    }
}
