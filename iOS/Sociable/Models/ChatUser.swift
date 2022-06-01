//
//  ChatUser.swift
//  Sociable
//
//

import Foundation

struct ChatUser: Identifiable, Codable, Hashable {

    var id: String? { uid }

    // getUserInfo endpoint

    var uid: String?
    var email: String?
    var displayName: String?
    var dob: String?
    var profilePic: profileImage?
    var bio: String?
    var friends: Array<String>?
    var msgs: [Msg2Comp]?
    
    // lhs ChatUser's values replaced by rhs ChatUser's non-nil values
    // after updating value, called by getUserInfo to get update local values
    func update(_ lhs: inout ChatUser, _ rhs: ChatUser) {
        lhs.email = rhs.email == nil ? lhs.email : rhs.email
        lhs.displayName = rhs.displayName == nil ? lhs.displayName : rhs.displayName
        lhs.dob = rhs.dob == nil ? lhs.dob : rhs.dob
        lhs.profilePic = rhs.profilePic == nil ? lhs.profilePic : rhs.profilePic
        lhs.bio = rhs.bio == nil ? lhs.bio : rhs.bio
        lhs.friends = rhs.friends == nil ? lhs.friends : rhs.friends
        lhs.msgs = rhs.msgs == nil ? lhs.msgs : rhs.msgs
    }
    
    struct profileImage: Hashable, Codable {
        let fileName: String
        let reference: String
        var url: String?
    }
}
