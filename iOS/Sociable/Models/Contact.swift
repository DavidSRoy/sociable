//
//  Contact.swift
//  Sociable
//
//  Created by Abas Hersi on 5/16/22.
//

import Contacts

struct Contacto: Identifiable {
    let contact: CNContact
    var id: String {contact.identifier}
    var fname: String {contact.givenName}
    var lname: String {contact.familyName}
    var phone: String? {contact.phoneNumbers.map(\.value).first?.stringValue}
    
    static func fetch(completion: @escaping(Result<[Contacto], Error>) -> Void) {
        let contid = CNContactStore().defaultContainerIdentifier()
        let pred = CNContact.predicateForContactsInContainer(withIdentifier: contid)
        let descrip = [
        CNContactIdentifierKey,
        CNContactGivenNameKey,
        CNContactFamilyNameKey,
        CNContactPhoneNumbersKey
        ]
        as [CNKeyDescriptor]
        do {
            let rawContacts = try CNContactStore().unifiedContacts(matching: pred, keysToFetch: descrip)
            completion(.success(rawContacts.map {.init(contact: $0)}))
        } catch {
            completion(.failure(error))
        }
    }
}

enum Permh: Identifiable {
    var id: String {UUID().uuidString}
    case erruser
    case fetchError(err: Error)
    var desc: String {
        switch self {
        case .erruser:
            return "Please make sure you have contact permissions enabled in your settings"
        case .fetchError(let error):
            return error.localizedDescription
        }
    }
}

