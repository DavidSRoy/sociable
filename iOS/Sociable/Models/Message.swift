//
//  Message.swift
//  Sociable
//
//  Created by Abas Hersi on 4/27/22.
//

import Foundation

struct Msg: Codable, Identifiable {
    var id: Int
    var text: String
    var recieved: Bool
    var time: Date
}
