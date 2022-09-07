//
//  UIImageView+.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 06.09.2022.
//

import UIKit

extension UIImageView {
    //Round shaped image
    func makeRounded() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.main.cgColor
    }
}
