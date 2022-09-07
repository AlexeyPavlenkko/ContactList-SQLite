//
//  AssemblyModuleBuilder.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 06.09.2022.
//

import Foundation
import UIKit

protocol AssemblyBuilderProtocol {
    func makeContactsListModule(router: RouterProtocol) -> UIViewController
    func makeContactDetailsModule(with contact: Contact?, router: RouterProtocol) -> UIViewController
}

class AssemblyModuleBuilder: AssemblyBuilderProtocol {
    
    func makeContactsListModule(router: RouterProtocol) -> UIViewController {
        let contactsListTVC = ContactListsTableViewController.instantiate() as! ContactListsTableViewController
        let contactsListViewModel = ContactsListViewModel(router: router)
        contactsListTVC.viewModel = contactsListViewModel
        return contactsListTVC
    }
    
    func makeContactDetailsModule(with contact: Contact?, router: RouterProtocol) -> UIViewController {
        let contactDetailsVC = ContactDetailsViewController.instantiate() as! ContactDetailsViewController
        let viewModel = ContactDetailsViewModel(originContact: contact, router: router)
        contactDetailsVC.viewModel = viewModel
        return contactDetailsVC
    }
}
