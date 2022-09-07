//
//  ContactListsTableViewController.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 07.09.2022.
//

import UIKit

class ContactListsTableViewController: UITableViewController {
 
    //MARK: - Variables
    var viewModel: ContactsListViewModelProtocol!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationController()
        setupViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadContacts()
    }
    
    //MARK: - Actions & @objc
    @objc private func addNewContact(_ sender: UIBarButtonItem) {
        viewModel.addNewContact()
    }
    
    //MARK: - Methods
    
    private func setupNavigationController() {
        title = "Contacts"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.main]
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.main]
        navigationItem.largeTitleDisplayMode = .automatic
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewContact(_:)))
        navigationItem.rightBarButtonItem?.tintColor = .main
        navigationItem.backBarButtonItem = nil
    }
    
    private func setupViewModel() {
        viewModel.contactsLoadedBlock = { [weak self] in
            self?.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource && UITableViewDelegate

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfContacts()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ContactTableViewCell.identifier , for: indexPath) as? ContactTableViewCell else { return UITableViewCell() }

        let contact = viewModel.getContactAtIndex(indexPath.row)
        cell.setupCellWith(contact)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width / 4
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.editContactAtIndex(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        viewModel.deleteContactAtIndex(indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

//MARK: - Storyboarded
extension ContactListsTableViewController: Storyboarded {
    static var storyboardName: String {
        "Main"
    }
    
    static var identifier: String {
        "ContactListsTableViewController"
    }
}
