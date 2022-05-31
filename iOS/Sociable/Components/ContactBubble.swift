//
//  ContactBubble.swift
//  Sociable
//
//  Created by Abas Hersi on 5/16/22.
//

import UIKit
import Contacts

final class ContactBubble: ObservableObject {
    @Published
    var contacts: [Contacto] = []
    @Published
    var perme: Permh? = .none
    
    init() {
        perm()
    }
    
    func settings() {
        perme = .none
        guard let seturl = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(seturl) {UIApplication.shared.open(seturl)}
            
    }
    
    private func retrieveContacts() {
        Contacto.fetch { [weak self] res in
            guard let self = self else {return}
            switch res {
            case .success(let fc):
                DispatchQueue.main.async {
                    self.contacts = fc.sorted(by: { $0.lname < $1.lname})
                }
            case .failure(let err):
                self.perme = .fetchError(err: err)
            }
        }
    }
    private func perm() {
        switch CNContactStore.authorizationStatus(for: .contacts) {
            
        case .authorized:
            <#code#>
        case .notDetermined, .restricted, .denied:
            CNContactStore().requestAccess(for: .contacts) { [weak self] granted, err in
                guard let self = self else { return }
                switch granted {
                case true:
                    self.retrieveContacts()
                case false:
                    DispatchQueue.main.async {
                        self.perme = .erruser
                    }
                }
            }
        default:
            fatalError("Unknown Error!")
        }
    }
}
