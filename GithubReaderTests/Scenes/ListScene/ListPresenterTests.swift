//
//  ListPresenterTests.swift
//  GithubReaderTests
//
//  Created by Andrii Horishnii on 2/14/18.
//

import XCTest
import CoreData
import PromiseKit
@testable import GithubReader

class ListPresenterTests: XCTestCase {
    
    var managedObjectContext: NSManagedObjectContext!

    var view: ListViewMock!
    var router: RouterMock!
    var storageService: UserStorageServiceMock!
    var requestService: UserRequestServiceMock!
    
    override func setUp() {
        super.setUp()
        
        managedObjectContext = setUpInMemoryManagedObjectContext()
        
        view = ListViewMock()
        router = RouterMock()
        storageService = UserStorageServiceMock()
        requestService = UserRequestServiceMock()
    }
    
    // MARK: Tests
    
    func testFetchUsersOnLoad() {
        let presenter = ListPresenter(view: view, router: router,
                                      userStorageService: storageService,
                                      userRequestService: requestService)
        
        requestService.fetchUsersFill = (users(), nil)
        
        let exp = expectation(description: "UserRequestService fetch")
        
        presenter.didLoad()
        
        after(interval: 0.1).then { _ -> Void in
            XCTAssertEqual(presenter.users.count, 5)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func testFetchUsersOnLoadFromStorage() {
        let presenter = ListPresenter(view: view, router: router,
                                      userStorageService: storageService,
                                      userRequestService: requestService)
        
        requestService.fetchUsersFill = (nil, NSError(domain: "TestErr", code: 1))
        storageService.fetchUsersFill = (users(from: 1, to: 3), nil)
        
        let exp = expectation(description: "UserStorageService fetch")
        
        presenter.didLoad()
        
        after(interval: 0.1).then { _ -> Void in
            XCTAssertEqual(presenter.users.count, 3)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func testDidPressedOnItem() {
        let presenter = ListPresenter(view: view, router: router,
                                      userStorageService: storageService,
                                      userRequestService: requestService,
                                      initUsers: users())
        
        presenter.didPressed(at: 0)
        XCTAssertEqual(router.navigateToDetailsUser?.userId, 1)
        
        presenter.didPressed(at: 2)
        XCTAssertEqual(router.navigateToDetailsUser?.userId, 3)
    }
    
    func testLoadMore() {
        let presenter = ListPresenter(view: view, router: router,
                                      userStorageService: storageService,
                                      userRequestService: requestService,
                                      initUsers: users())
        
        requestService.fetchUsersFill = (users(from: 6, to: 10), nil)
        
        let exp = expectation(description: "UserRequestService fetch")
        
        presenter.didScrollToButtom()
        XCTAssertEqual(requestService.fetchUsersLastId, 5)
        
        after(interval: 0.1).then { _ -> Void in
            XCTAssertEqual(presenter.users.count, 10)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
    }
    
    func testLoadMoreReachedTheEnd() {
        let presenter = ListPresenter(view: view, router: router,
                                      userStorageService: storageService,
                                      userRequestService: requestService,
                                      initUsers: users())
        
        requestService.fetchUsersFill = ([], nil)
        
        let exp = expectation(description: "UserRequestService fetch")
        
        presenter.didScrollToButtom()
        
        after(interval: 0.1).then { _ -> Void in
            XCTAssertEqual(presenter.users.count, 5)
            XCTAssertFalse(self.view.refreshTableViewCalled)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.2)
    }

    // MARK: Utils
    
    func setUpInMemoryManagedObjectContext() -> NSManagedObjectContext {
        let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        } catch {
            print("Adding in-memory persistent store failed")
        }
        
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
    
    func users(from: Int = 1, to: Int = 5) -> [User] {
        return (from...to).map { User.getUser($0, context: managedObjectContext) }
    }
    
}

class ListViewMock: ListViewProtocol {
    
    var refreshTableViewCalled = false
    func refreshTableView() {
        refreshTableViewCalled = true
    }

}

class RouterMock: RouterProtocol {
    
    var navigateToDetailsUser: User?
    func navigateToDetails(user: User) {
        navigateToDetailsUser = user
    }
    
}

class UserStorageServiceMock: UserStorageServiceProtocol {
    
    var fetchUserUpdateWithJson: User?
    func fetchUser(updateWithJson: [String : Any]) -> User? {
        return fetchUserUpdateWithJson
    }
    
    var fetchUsersLastId: Int?
    var fetchUsersFill: (users: [User]?, error: Error?)!
    func fetchUsers(lastId: Int?) -> Promise<[User]> {
        fetchUsersLastId = lastId
        return Promise { fulfill, reject in
            if let error = fetchUsersFill?.error {
                reject(error)
            }
            if let users = fetchUsersFill?.users {
                fulfill(users)
            }
        }
    }
    
    var saveCalled = false
    func save() {
        saveCalled = true
    }

}

class UserRequestServiceMock: UserRequestServiceProtocol {
    
    var fetchUsersLastId: Int?
    var fetchUsersFill: (users: [User]?, error: Error?)!
    func fetchUsers(lastId: Int?) -> Promise<[User]> {
        fetchUsersLastId = lastId
        return Promise { fulfill, reject in
            if let error = fetchUsersFill?.error {
                reject(error)
            }
            if let users = fetchUsersFill?.users {
                fulfill(users)
            }
        }
    }

}

extension User {
    
    static func getUser(_ userId: Int, context: NSManagedObjectContext) -> User {
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let user = User(entity: entity!, insertInto: context)
        user.userId = userId
        return user
    }
    
}
