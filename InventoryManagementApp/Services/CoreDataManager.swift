//
//  CoreDataManager.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation

import CoreData

final class CoreDataStorage { // This manages Core Data operations
    static var shared = CoreDataStorage() // is a shared instance
    
    private init() {} // This is here to make sure there is only one instance of the class
    
    
    // MARK: - Core Data stack
    
    private lazy var persistentContainer: NSPersistentContainer = { // Initialises the NSP
        print(NSPersistentContainer.defaultDirectoryURL()) // prints the default URL for Core data
        
        let container = NSPersistentContainer(name: "InventoryManagementApp") // THis is the container we created for the inventory management app
        
        let url = URL.storeURL(for: "group.Isabelle.InventoryManagementApp", databaseName: "InventoryManagementApp")
//        let url = FileManager.appGroupContainerURL.appendingPathComponent("InventoryManagementApp.sqlite")
        let storeDescription = NSPersistentStoreDescription (url: url)
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? { // error handling here :)
                assertionFailure("CoreDataStorage: Unresolved error \(error), \(error.userInfo)")
            }
        })
    
        
        return container
    }()
    
    lazy var context = persistentContainer.viewContext // Gives access to the main managed object context
    
    // MARK: - Core Data Saving support
    
    func saveContext () { // save function of the context to a persistent container
        let context = persistentContainer.viewContext
        if context.hasChanges { // good error handling method , we are checking to ensure that there are event any changes before saving it to the container
            do {
                try context.save() // save context
            } catch {
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)") // error handling, see if there are any error logs 
            }
        }
    }
    
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
    
}

public extension URL {
    static func storeURL( for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL (forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError ("Unable to create URL for \(appGroup)")
        }
        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
