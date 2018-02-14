//
//  NSManagedObjectContextExtension.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/12/18.
//

import UIKit
import CoreData

protocol CoreDateManagerProtocol {
    var persistentContainer: NSPersistentContainer { get }
    func saveContext()
}

class CoreDateManager: CoreDateManagerProtocol {
    
    static let shared = CoreDateManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "GithubReader")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
