//
//  ContactDetailsViewModel.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 06.09.2022.
//

import UIKit

protocol ContactDetailsViewModelProtocol: AnyObject {
    init(originContact: Contact?, router: RouterProtocol?)
    var unableToSaveContactBlock: ((String) -> Void)? { get set }
    var getContactInfoBlock: ((Contact?) -> Void)? { get set }
    func getContact()
    func cancelTapped()
    func save(with contact: Contact)
}

class ContactDetailsViewModel: ContactDetailsViewModelProtocol{
    private var router: RouterProtocol?
    private let originContact: Contact?
    
    required init(originContact: Contact?, router: RouterProtocol?) {
        self.originContact = originContact
        self.router = router
    }
    
    var unableToSaveContactBlock: ((String) -> Void)?
    var getContactInfoBlock: ((Contact?) -> Void)?
    
    func getContact() {
        getContactInfoBlock?(originContact)
    }
    
    func save(with contact: Contact) {
        if originContact != nil {
            updateExistingContact(contact)
        } else {
            saveNewContact(contact)
        }
    }
    
    func cancelTapped() {
        router?.popToRoot()
    }
    
    private func saveNewContact(_ contact: Contact) {
        let contactAddedToTable = SQLiteCommands.insertRow(with: contact)
        //Phone number is unique to each contact
        if contactAddedToTable == true {
            router?.popToRoot()
        } else {
            unableToSaveContactBlock?("This contact cannot be created because this phone number already exists in your contact list")
        }
    }
    
    private func updateExistingContact(_ contact: Contact) {
        guard let existedContact = originContact else { return }
        let updatedContact = Contact(id: existedContact.id, firstName: contact.firstName, lastName: contact.lastName, phoneNumber: contact.phoneNumber, photo: contact.photo)
        let contactUpdatedToTable = SQLiteCommands.updateRow(with: updatedContact)
        
        //Contact was succesfully updated
        if contactUpdatedToTable == true {
            router?.popToRoot()
        } else {
            unableToSaveContactBlock?("Unable to update this contact. Please try again later.")
        }
    }
}

