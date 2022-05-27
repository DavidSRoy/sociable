//
//  ChatUser.swift
//  Sociable
//
//

import Foundation

struct ChatUser: Codable {
    let uid: String?
    let email: String?
    let name: String
    let profileImageUrl: String?
    let status: String?
    var msgs: [Msg2Comp]
}
