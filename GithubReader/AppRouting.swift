//
//  AppRouting.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/11/18.
//

import UIKit

struct AppRouting {
    
    struct ListScene {
        let navigationController = UIStoryboard(name: "ListScene", bundle: nil)
            .instantiateViewController(withIdentifier: "NavigationController") as? UINavigationController
    }
    
    struct DetailsScene {
        let detailsViewController = UIStoryboard(name: "DetailsScene", bundle: nil)
            .instantiateViewController(withIdentifier: "DetailsViewController") as? DetailsViewController
    }
    
}
