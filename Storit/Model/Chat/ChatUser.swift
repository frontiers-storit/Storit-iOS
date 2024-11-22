//
//  ChatUser.swift
//  Storit
//
//  Created by iOS Nasmedia on 10/18/24.
//

import Foundation

struct ChatUser: Codable, Identifiable, Hashable, Equatable {
    let id: String
    let name: String
    let avatarURL: URL?
    let isCurrentUser: Bool
}
