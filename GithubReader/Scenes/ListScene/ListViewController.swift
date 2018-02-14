//
//  ViewController.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/7/18.
//

import UIKit

protocol ListViewProtocol: class {
    func refreshTableView()
}

class ListViewController: UIViewController {
    
    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    var presenter: ListPresenterProtocol!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        presenter.didLoad()
    }

}

extension ListViewController: ListViewProtocol {
    
    func refreshTableView() {
        tableView.reloadData()
    }
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didPressed(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserTableViewCell.cellIdentity,
                                                 for: indexPath)
        
        let user = presenter.users[indexPath.row]
        (cell as? UserTableViewCell)?.fillCell(user: user)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastIndex {
            presenter.didScrollToButtom()
        }
    }
    
}
