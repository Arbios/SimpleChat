//
//  Message.swift
//  SimpleChat
//
//  Created by Arbi Bashaev on 11.10.2024.
//

import Foundation

struct Message: Hashable {
    let id: UUID
    let text: String
    let isSentByCurrentUser: Bool
}
