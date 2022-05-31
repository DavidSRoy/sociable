//
//  ChatUser.swift
//  Sociable
//
//

import Foundation

struct ChatUser: Identifiable, Codable, Hashable {

    var id: String? { uid }

    // getUserInfo endpoint

    let uid: String?
    var email: String?
    var displayName: String?
    var dob: String?
    var profileImageUrl: String?
    var status: String?
    var friends: Array<String>?
    var msgs: [Msg2Comp]?

    // lhs ChatUser's values replaced by rhs ChatUser's non-nil values
    // after updating value, called by getUserInfo to get update local values
    func update(_ lhs: inout ChatUser, _ rhs: ChatUser) {
        lhs.email = rhs.email == nil ? lhs.email : rhs.email
        lhs.displayName = rhs.displayName == nil ? lhs.displayName : rhs.displayName
        lhs.dob = rhs.dob == nil ? lhs.dob : rhs.dob
        lhs.profileImageUrl = rhs.profileImageUrl == nil ? lhs.profileImageUrl : rhs.profileImageUrl
        lhs.status = rhs.status == nil ? lhs.status : rhs.status
        lhs.friends = rhs.friends == nil ? lhs.friends : rhs.friends
        lhs.msgs = rhs.msgs == nil ? lhs.msgs : rhs.msgs
    }
}
