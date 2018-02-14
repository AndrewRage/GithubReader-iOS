//
//  UserStorageService.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/13/18.
//

import Foundation
import CoreData
import PromiseKit
import ObjectMapper

protocol UserStorageServiceProtocol {
    func fetchUser(updateWithJson: [String: Any]) -> User?
    func fetchUsers(lastId: Int?) -> Promise<[User]>
    func save()
}

class UserStorageService: UserStorageServiceProtocol {
    
    fileprivate let coreDateManager: CoreDateManagerProtocol
    
    init(coreDateManager: CoreDateManagerProtocol) {
        self.coreDateManager = coreDateManager
    }
    
    func fetchUser(updateWithJson: [String: Any]) -> User? {
        let map = Map(mappingType: .fromJSON, JSON: updateWithJson)
        guard let id = map["id"].currentValue as? Int else {
            return nil
        }
        let context = CoreDateManager.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<User>(entityName: "User")
        fetchRequest.predicate = NSPredicate(format: "%K == %i", #keyPath(User.userId), id)
        guard let results = try? context.fetch(fetchRequest) else {
            return nil
        }
        if results.count > 0 {
            let user = results[0]
            user.mapping(map: map)
            return user
        }
        return nil
    }
    
    func fetchUsers(lastId: Int?) -> Promise<[User]> {
        return Promise { fulfill, reject in
            let context = coreDateManager.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<User>(entityName: "User")
            let sort = NSSortDescriptor(key: #keyPath(User.userId), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            if let lastId = lastId {
                fetchRequest.predicate = NSPredicate(format: "%K > \(lastId)",
                                                     #keyPath(User.userId))
            }
            do {
                let fetchedResults = try context.fetch(fetchRequest)
                fulfill(fetchedResults)
            } catch let error as NSError {
                reject(error)
            }
        }
    }
    
    func save() {
        coreDateManager.saveContext()
    }
    
}
