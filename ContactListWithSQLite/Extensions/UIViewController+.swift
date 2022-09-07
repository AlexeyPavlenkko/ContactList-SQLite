//
//  UIViewController.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 06.09.2022.
//

import UIKit

extension UIViewController {
    //Alert message
    func showError(_ title: String?, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}

