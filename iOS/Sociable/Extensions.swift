//
//  Extensions.swift
//  Sociable
//
//  Created by Abas Hersi on 4/27/22.
//

import SwiftUI
import Foundation

extension View {
    // Extension for adding rounded corners to specific corners
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RC(corners: corners, radius: radius))
    }
    
    func onKeyboard(_ keyboardYOffset: Binding<CGFloat>) -> some View {
        return ModifiedContent(content: self, modifier: KeyboardModifier(keyboardYOffset))
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

struct KeyboardModifier: ViewModifier {
    @Binding var keyboardYOffset: CGFloat
    let keyboardWillAppearPublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
    let keyboardWillHidePublisher = NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
    
    init(_ offset: Binding<CGFloat>) {
        _keyboardYOffset = offset
    }
    
    func body(content: Content) -> some View {
        return content.offset(x: 0, y: -$keyboardYOffset.wrappedValue)
            .animation(.easeInOut(duration: 0.33))
            .onReceive(keyboardWillAppearPublisher) { notification in
                let keyWindow = UIApplication.shared.connectedScenes
                    .filter { $0.activationState == .foregroundActive }
                    .map { $0 as? UIWindowScene }
                    .compactMap { $0 }
                    .first?.windows
                    .filter { $0.isKeyWindow }
                    .first
                
                let yOffset = keyWindow?.safeAreaInsets.bottom ?? 0
                
                let keyboardFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero
                
                self.$keyboardYOffset.wrappedValue = keyboardFrame.height - yOffset
            }.onReceive(keyboardWillHidePublisher) { _ in
                self.$keyboardYOffset.wrappedValue = 0
            }
    }
}

// https://stackoverflow.com/a/58908409
struct NavigationButton<Destination: View, Label: View>: View {
    var action: () -> Void = { }
    var destination: () -> Destination
    var label: () -> Label
    
    @State private var isActive: Bool = false
    
    var body: some View {
        Button(action: {
            self.action()
            self.isActive.toggle()
        }) {
            self.label()
                .background(
                    ScrollView { // Fixes a bug where the navigation bar may become hidden on the pushed view
                        NavigationLink(destination: LazyDestination { self.destination() },
                                       isActive: self.$isActive) { EmptyView() }
                    }
                )
        }
    }
}

// This view lets us avoid instantiating our Destination before it has been pushed.
struct LazyDestination<Destination: View>: View {
    var destination: () -> Destination
    var body: some View {
        self.destination()
    }
}
