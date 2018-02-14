//
//  ListPresenter.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/7/18.
//

import Foundation
import PromiseKit

protocol ListPresenterProtocol: class {
    var users: [User] { get }
    func didLoad()
    func didScrollToButtom()
    func didPressed(at index: Int)
}

class ListPresenter: ListPresenterProtocol {
    
    fileprivate(set) var users: [User] = []
    fileprivate unowned let view: ListViewProtocol
    fileprivate let router: RouterProtocol
    fileprivate let userStorageService: UserStorageServiceProtocol
    fileprivate let userRequestService: UserRequestServiceProtocol
    
    required init(view: ListViewProtocol, router: RouterProtocol,
                  userStorageService: UserStorageServiceProtocol,
                  userRequestService: UserRequestServiceProtocol) {
        self.view = view
        self.router = router
        self.userStorageService = userStorageService
        self.userRequestService = userRequestService
    }
    
    required init(view: ListViewProtocol, router: RouterProtocol,
                  userStorageService: UserStorageServiceProtocol,
                  userRequestService: UserRequestServiceProtocol,
                  initUsers: [User]) {
        self.view = view
        self.router = router
        self.userStorageService = userStorageService
        self.userRequestService = userRequestService
        self.users.append(contentsOf: initUsers)
    }
    
    func didLoad() {
        fetchUsers()
    }
    
    func didScrollToButtom() {
        fetchUsers()
    }
    
    func didPressed(at index: Int) {
        router.navigateToDetails(user: users[index])
    }
    
    fileprivate func fetchUsers() {
        let lastId = users.last?.userId
        userRequestService.fetchUsers(lastId: lastId).recover { _ -> Promise<[User]> in
            return self.userStorageService.fetchUsers(lastId: lastId)
        }.then { [weak self] users -> Void in
            guard let `self` = self, users.count > 0 else { return }
            `self`.users.append(contentsOf: users)
            `self`.view.refreshTableView()
            `self`.userStorageService.save()
        }.catch { error in
            print(error)
        }
    }

}
