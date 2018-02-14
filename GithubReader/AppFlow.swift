//
//  AppFlow.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/11/18.
//

import UIKit

class AppFlow {
    
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        showListScene()
    }
    
    private func showListScene() {
        let navigationController = AppRouting.ListScene().navigationController
        let firstViewController = navigationController?.viewControllers.first
        guard let listViewController = firstViewController as? ListViewController else {
            fatalError("Unresolved error can't get ListViewController")
        }
        let userStorageService = UserStorageService(coreDateManager: CoreDateManager.shared)
        let router = Router(viewController: listViewController)
        let listPresenter = ListPresenter(view: listViewController, router: router,
                                          userStorageService: userStorageService,
                                          userRequestService: UserRequestService(
                                            userStorageService: userStorageService))
        listViewController.presenter = listPresenter
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
    
    private func show() {
        let view = AppRouting.DetailsScene().detailsViewController
        let presenter = DetailsPresenter(view: view!, user: User())
        view?.presenter = presenter
        window.rootViewController = view
        window.makeKeyAndVisible()
    }
    
}
