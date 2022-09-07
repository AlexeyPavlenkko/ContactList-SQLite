//
//  ContactTableViewCell.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 07.09.2022.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    static let identifier = "contactCell"
    
    @IBOutlet weak private var contactPhototImageView: UIImageView!
    @IBOutlet weak private var contactNameLabel: UILabel!
    @IBOutlet weak private var contactPhoneNumberLabel: UILabel!
    
   
    //Setup All contact values
    func setupCellWith(_ contact: Contact) {
        contactNameLabel.text = contact.firstName + " " + contact.lastName
        contactPhoneNumberLabel.text = contact.phoneNumber
        contactPhototImageView.image = UIImage(data: contact.photo) ?? UIImage(named: "user")!
        //contactPhototImageView.makeRounded()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contactPhototImageView.makeRounded()
    }
}
