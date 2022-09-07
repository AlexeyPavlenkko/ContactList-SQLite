//
//  Router.swift
//  ContactListWithSQLite
//
//  Created by Алексей Павленко on 06.09.2022.
//

import UIKit

protocol RouterProtocol {
    var navigationController: UINavigationController? { get set }
    var assemlyBuilder: AssemblyBuilderProtocol?  { get set }
    func setupInitialViewController()
    func goToContactDetailsViewControllerWith(contact: Contact?)
    func popToRoot()
}

class Router: RouterProtocol {
    var navigationController: UINavigationController?
    var assemlyBuilder: AssemblyBuilderProtocol?
    
    init(navigation: UINavigationController, builder: AssemblyBuilderProtocol) {
        self.navigationController = navigation
        self.assemlyBuilder = builder
    }
    
    func setupInitialViewController() {
        guard let navigationController = navigationController else { return }
        guard let vc = assemlyBuilder?.makeContactsListModule(router: self) else { return }
        navigationController.viewControllers = [vc]
    }
    
    func goToContactDetailsViewControllerWith(contact: Contact?) {
        guard let navigationController = navigationController else { return }
        guard let vc = assemlyBuilder?.makeContactDetailsModule(with: contact, router: self) else { return }
        navigationController.pushViewController(vc, animated: true)
    }
    
    func popToRoot() {
        guard let navigationController = navigationController else { return }
        navigationController.popToRootViewController(animated: true)
    }
}
