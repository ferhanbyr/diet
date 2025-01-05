//
//  ChatMessages.swift
//  diet.io
//
//  Created by Ferhan Bayır on 5.01.2025.
//

import Foundation

struct ChatMessages: Identifiable, Equatable {
    let id = UUID()
    let content: String
    let isUser: Bool
    let timestamp: Date
    
    static func == (lhs: ChatMessages, rhs: ChatMessages) -> Bool {
        lhs.id == rhs.id &&
        lhs.content == rhs.content &&
        lhs.isUser == rhs.isUser &&
        lhs.timestamp == rhs.timestamp
    }
}
