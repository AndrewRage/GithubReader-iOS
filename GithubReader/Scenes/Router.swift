//
//  Router.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/13/18.
//

import UIKit

protocol RouterProtocol {
    func navigateToDetails(user: User)
}

class Router: RouterProtocol {

    weak var viewController: UIViewController!
    
    required init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    private func show(_ viewController: UIViewController) {
        self.viewController.navigationController?.show(viewController, sender: nil)
    }
    
    func navigateToDetails(user: User) {
        guard let viewController = AppRouting.DetailsScene().detailsViewController else {
            return
        }
        let presenter = DetailsPresenter(view: viewController, user: user)
        viewController.presenter = presenter
        show(viewController)
    }
    
}
