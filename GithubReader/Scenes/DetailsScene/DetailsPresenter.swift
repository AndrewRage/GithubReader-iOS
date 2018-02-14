//
//  DetailsPresenter.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/8/18.
//

import Foundation

protocol DetailsPresenterProtocol: class {
    func didLoad()
}

class DetailsPresenter: DetailsPresenterProtocol {
    
    fileprivate unowned let view: DetailsViewProtocol
    fileprivate let user: User
    
    required init(view: DetailsViewProtocol, user: User) {
        self.view = view
        self.user = user
    }
    
    func didLoad() {
        view.show(user: user)
    }
}
