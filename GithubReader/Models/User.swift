//
//  User.swift
//  GithubReader
//
//  Created by Andrii Horishnii on 2/10/18.
//

import Foundation
import CoreData
import Alamofire
import ObjectMapper

@objc(User)
class User: NSManagedObject, Mappable {
    @NSManaged var userId: Int
    @NSManaged var login: String!
    @NSManaged var avatarUrl: String?
    @NSManaged var gravatarId: String?
    @NSManaged var url: String?
    @NSManaged var htmlUrl: String?
    @NSManaged var followersUrl: String?
    @NSManaged var followingUrl: String?
    @NSManaged var gistsUrl: String?
    @NSManaged var starredUrl: String?
    @NSManaged var subscriptionsUrl: String?
    @NSManaged var organizationsUrl: String?
    @NSManaged var reposUrl: String?
    @NSManaged var eventsUrl: String?
    @NSManaged var receivedEventsUrl: String?
    @NSManaged var type: String?
    @NSManaged var siteAdmin: Bool

    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        let context = CoreDateManager.shared.persistentContainer.viewContext
        super.init(entity: entity, insertInto: context)
    }

    required init?(map: Map) {
        let context = CoreDateManager.shared.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        super.init(entity: entity!, insertInto: context)

        mapping(map: map)
    }

    func mapping(map: Map) {
        userId <- map["id"]
        login <- map["login"]
        avatarUrl <- map["avatar_url"]
        gravatarId <- map["gravatar_id"]
        url <- map["url"]
        htmlUrl <- map["html_url"]
        followersUrl <- map["followers_url"]
        followingUrl <- map["following_url"]
        gistsUrl <- map["gists_url"]
        starredUrl <- map["starred_url"]
        subscriptionsUrl <- map["subscriptions_url"]
        organizationsUrl <- map["organizations_url"]
        reposUrl <- map["repos_url"]
        eventsUrl <- map["events_url"]
        receivedEventsUrl <- map["received_events_url   "]
        type <- map["type"]
        siteAdmin <- map["site_admin"]
    }
}
