//
//  CoreDataPersistence.swift
//  RedditTest
//
//  Created by Brian Sztamfater on 19/11/2020.
//  Copyright © 2020 Brian Sztamfater. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPersistence: Persistence {
    
    lazy var dispatchQueue: DispatchQueue = {
        let dispatchQueue = DispatchQueue(label: "CoreDataPersistence")
        return dispatchQueue
    }()
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.mergePolicy = NSOverwriteMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    public func getAll<T: Migratable>(conditions: [String : String]?, orderBy attributeNames: [String]? = nil) -> [T] {
        
        let managedContext = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.Entity.self))
        fetchRequest.sortDescriptors = attributeNames?.map { NSSortDescriptor(key: $0, ascending: false) }
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if let coreDataItems = result as? [T.Entity] {
                let items = coreDataItems.map { T.build(from: $0)! }
                return items
            } else {
                return []
            }
        } catch {
            print("Couldn't get items from Core Data")
            return []
        }
    }
    
    public func getCustomBy<T: Migratable>(attributeName: String, attributeValue: String) -> T? {
        let managedContext = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.Entity.self))
        fetchRequest.predicate = NSPredicate(format: "\(attributeName) = %@", attributeValue)

        do {
            let result = try managedContext.fetch(fetchRequest)
            if let coreDataObject = result.first as? T.Entity {
                return T.build(from: coreDataObject)
            }
            return nil
        } catch {
            print("Couldn't get item from Core Data by id")
            return nil
        }
    }
    
    public func getBy<T: Migratable>(id: Int64) -> T? {
        let managedContext = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.Entity.self))
        fetchRequest.predicate = NSPredicate(format: "id = %i", id)

        do {
            let result = try managedContext.fetch(fetchRequest)
            let coreDataObject = result[0] as! T.Entity
            return T.build(from: coreDataObject)
        } catch {
            print("Couldn't get item from Core Data by id")
            return nil
        }
    }
    
    public func getBy<T: Migratable>(id: String) -> T? {
        let managedContext = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: T.Entity.self))
        fetchRequest.predicate = NSPredicate(format: "id = %@", id)

        do {
            let result = try managedContext.fetch(fetchRequest)
            if let coreDataObject = result.first as? T.Entity {
                return T.build(from: coreDataObject)
            }
            return nil
        } catch {
            print("Couldn't get item from Core Data by id")
            return nil
        }
    }
    
    public func save<T: Migratable>(object: T) {
        dispatchQueue.sync { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let managedContext = weakSelf.persistentContainer.newBackgroundContext()
            managedContext.mergePolicy = NSOverwriteMergePolicy

            do {
                let entity = try object.export(to: managedContext as! T.Context) as! NSManagedObject
                managedContext.insert(entity)
                try managedContext.save()
            } catch {
                print(error)
                return
            }
        }
    }
    
    public func saveAll<T: Migratable>(objects: [T]) {
        objects.forEach { self.save(object: $0) }
    }
    
    public func delete<T: Migratable>(object: T) {
        dispatchQueue.sync { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let managedContext = weakSelf.persistentContainer.newBackgroundContext()
            managedContext.mergePolicy = NSOverwriteMergePolicy

            do {
                let coreDataObject = try object.export(to: managedContext as! T.Context) as! NSManagedObject
                try managedContext.save()
                managedContext.delete(coreDataObject)
                try managedContext.save()
            } catch {
                print(error)
                return
            }
        }
    }
    
    public func deleteAll<T: Migratable>(objects: [T]) {
        dispatchQueue.sync { [weak self] in
            guard let weakSelf = self else {
                return
            }
            let managedContext = weakSelf.persistentContainer.newBackgroundContext()
            managedContext.mergePolicy = NSOverwriteMergePolicy

            do {
                for object in objects {
                    let coreDataObject = try object.export(to: managedContext as! T.Context) as! NSManagedObject
                    try managedContext.save()
                    managedContext.delete(coreDataObject)
                }
                try managedContext.save()
            } catch {
                print(error)
                return
            }
        }
    }
}
