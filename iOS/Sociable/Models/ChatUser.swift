//
//  ChatUser.swift
//  Sociable
//
//

import Foundation

struct ChatUser: Identifiable, Codable, Hashable {
    
    var id: String? { uid }
    
    let uid: String?
    var email: String?
    var name: String?
    var firstName: String?  //
    var lastName: String?   // getUsers
    var dob: String?        //
    var profileImageUrl: String?
    var status: String?
    var msgs: [Msg2Comp]?
}
