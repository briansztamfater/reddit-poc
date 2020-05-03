//
//  BaseService.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 4/13/17.
//  Copyright © 2017 Brian Sztamfater. All rights reserved.
//

import Foundation

class BaseService<T: PersistenceObject>  {
    
    internal let persistence: Persistence!
    internal let restClient: RestClient!

    init(persistence: Persistence, restClient: RestClient) {
        self.persistence = persistence
        self.restClient = restClient
    }
    
    public func getAll(conditions: [String : String]? = nil, orderBy attributeNames: [String]? = nil) -> [T] {
        return persistence.getAll(conditions: conditions, orderBy: attributeNames)
    }
    
    public func getEntityBy(id: Int64) -> T? {
        return persistence.getBy(id: id)
    }

    public func getEntityBy(id: String) -> T? {
        return persistence.getBy(id: id)
    }

    public func updateLocalStoreWithServerInfo(onSuccess: (() -> Void)? = nil, onError: ((Error) -> Void)? = nil) {
        preconditionFailure("This method must be overridden")
    }
    
    public func getNotificationKeyName() -> Notification.Name {
        return Notification.Name(rawValue:persistence.getNotificationTag(for: T.databaseTableName))
    }
}
