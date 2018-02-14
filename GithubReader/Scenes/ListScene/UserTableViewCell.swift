//
//  UserTableViewCell.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/12/18.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    public static let cellIdentity = "UserTableViewCell"
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    public func fillCell(user: User) {
        nameLabel.text = user.login
        
        let url = URL(string: user.avatarUrl ?? "")
        avatarImageView.kf.setImage(with: url)
    }
    
}
