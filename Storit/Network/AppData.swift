//
//  AppData.swift
//  Storit
//
//  Created by iOS Nasmedia on 11/14/24.
//

import Foundation

enum AppData {
    
    @UserDefaultsWrapper(key: "nickname", defaultValue: "")
    static var nickname
}
