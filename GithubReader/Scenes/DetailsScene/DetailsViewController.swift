//
//  DetailsViewController.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/8/18.
//

import UIKit

protocol DetailsViewProtocol: class {
    func show(user: User)
}

class DetailsViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var userTypeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var presenter: DetailsPresenterProtocol!
    
    // MARK: Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "User Details"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.didLoad()
    }
    
}

extension DetailsViewController: DetailsViewProtocol {
    
    func show(user: User) {
        nameLabel.text = user.login
        userTypeLabel.text = user.type
        
        let url = URL(string: user.avatarUrl ?? "")
        avatarImageView.kf.setImage(with: url)
    }
    
}
