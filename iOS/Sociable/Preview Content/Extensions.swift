//
//  Extensions.swift
//  Sociable
//
//  Created by Abas Hersi on 4/27/22.
//

import SwiftUI
import Foundation

// Extension for adding rounded corners to specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RC(corners: corners, radius: radius))
    }
}

// Custom RoundedCorner shape used for cornerRadius extension above
struct RC: Shape {
    var corners: UIRectCorner = .allCorners
    var radius: CGFloat = .infinity
    func path(in rect: CGRect) -> Path {
        let rcs = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(rcs.cgPath)
    }
}
