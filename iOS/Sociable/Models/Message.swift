//
//  Message.swift
//  Sociable
//
//  Created by Abas Hersi on 4/27/22.
//

import Foundation

public struct Msg: Hashable, Codable, Identifiable, Comparable {
    public var id: String
    public var text: String
    public var recieved: Bool
    public var time: Date
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(text)
        hasher.combine(time)
    }
}
