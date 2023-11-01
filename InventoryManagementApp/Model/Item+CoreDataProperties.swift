//
//  Item+CoreDataProperties.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//
//

import Foundation
import CoreData

// An extension of the item class adidng methods for the item entity
extension Item {

    //creates a fetch request for the item entity
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    
    // This variables are the attributes of the item
    @NSManaged public var name: String?
    @NSManaged public var inventory: Int32
    @NSManaged public var lower_limit: Int32
    @NSManaged public var barcode: String?
    @NSManaged public var takes: NSSet?

}

// MARK: Generated accessors for takes
extension Item {

    
    // add a single stocktake object to the takes relationship
    @objc(addTakesObject:)
    @NSManaged public func addToTakes(_ value: StockTake)
// This just removes the stocktake object from the takes
    @objc(removeTakesObject:)
    @NSManaged public func removeFromTakes(_ value: StockTake)
// Adds multiple stoctakes object
    @objc(addTakes:)
    @NSManaged public func addToTakes(_ values: NSSet)
// removes multiple stocktakes object 
    @objc(removeTakes:)
    @NSManaged public func removeFromTakes(_ values: NSSet)

}

extension Item : Identifiable {

}
