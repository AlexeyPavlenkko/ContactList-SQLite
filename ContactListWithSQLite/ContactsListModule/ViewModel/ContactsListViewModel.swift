//
//  ContactsListViewModel.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 07.09.2022.
//

import Foundation

protocol ContactsListViewModelProtocol: AnyObject {
    var contactsLoadedBlock: (() -> Void)? { get set }
    func loadContacts()
    func getNumberOfContacts() -> Int
    func getContactAtIndex(_ index: Int) -> Contact
    func addNewContact()
    func editContactAtIndex(_ index: Int)
    func deleteContactAtIndex(_ index: Int)
}

class ContactsListViewModel: ContactsListViewModelProtocol {
    private var contactArray = [Contact]()
    private var router: RouterProtocol
    
    init(router: RouterProtocol) {
        self.router = router
    }
        
    var contactsLoadedBlock: (() -> Void)?
    
    func loadContacts() {
        SQLiteCommands.createTable()
        contactArray = SQLiteCommands.presentRows() ?? []
        contactsLoadedBlock?()
    }
    
    func getNumberOfContacts() -> Int {
        return contactArray.count
    }
    
    func getContactAtIndex(_ index: Int) -> Contact {
        return contactArray[index]
    }
    
    func deleteContactAtIndex(_ index: Int) {
        let contactToDelete = getContactAtIndex(index)
        contactArray.remove(at: index)
        SQLiteCommands.deleteContact(contact: contactToDelete)
    }
    
    func addNewContact() {
        router.goToContactDetailsViewControllerWith(contact: nil)
    }
    
    func editContactAtIndex(_ index: Int) {
        let contactToEdit = getContactAtIndex(index)
        router.goToContactDetailsViewControllerWith(contact: contactToEdit)
    }
}
