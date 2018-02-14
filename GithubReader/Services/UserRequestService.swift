//
//  UserRequestService.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/11/18.
//

import Foundation
import Alamofire
import ObjectMapper
import PromiseKit

protocol UserRequestServiceProtocol {
    func fetchUsers(lastId: Int?) -> Promise<[User]>
}

class UserRequestService: UserRequestServiceProtocol {
    
    static let url = "https://api.github.com/users"
    let userStorageService: UserStorageServiceProtocol
    
    init(userStorageService: UserStorageServiceProtocol) {
        self.userStorageService = userStorageService
    }
    
    func fetchUsers(lastId: Int?) -> Promise<[User]> {
        
        var parameters = [String: Any]()
        if lastId != nil {
            parameters["since"] = lastId
        }

        return Promise { fulfill, reject in
            request(UserRequestService.url, parameters: parameters)
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success(let json):
                        guard let json = json as? [AnyObject] else {
                            fulfill([])
                            return
                        }
                        var users: [User] = []
                        for item in json {
                            guard let item = item as? [String : Any] else {
                                break
                            }
                            if let user = self.userStorageService.fetchUser(updateWithJson: item) ??
                                Mapper<User>().map(JSON: item) {
                                users.append(user)
                            }
                        }
                        fulfill(users)
                    case .failure(let error):
                        reject(error)
                    }
            }
        }
    }
    
}
