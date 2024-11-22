//
//  Int+.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/8/24.
//

import Foundation

extension Int {
    func timestamptoDate() -> Date {
        return  Date(timeIntervalSince1970: TimeInterval(self))
    }
}
