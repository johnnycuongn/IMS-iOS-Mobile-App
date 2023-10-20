//
//  CoreDataManager.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation

import CoreData

final class CoreDataStorage {
    static var shared = CoreDataStorage()
    
    private init() {}
    
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = {
        print(NSPersistentContainer.defaultDirectoryURL())
        
        let container = NSPersistentContainer(name: "InventoryManagementApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("CoreDataStorage: Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var context = persistentContainer.viewContext
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                /// TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }
    
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
}
