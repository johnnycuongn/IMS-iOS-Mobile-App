//
//  Item+CoreDataProperties.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var name: String?
    @NSManaged public var inventory: Int32
    @NSManaged public var lower_limit: Int32
    @NSManaged public var barcode: String?
    @NSManaged public var takes: NSSet?

}

// MARK: Generated accessors for takes
extension Item {

    @objc(addTakesObject:)
    @NSManaged public func addToTakes(_ value: StockTake)

    @objc(removeTakesObject:)
    @NSManaged public func removeFromTakes(_ value: StockTake)

    @objc(addTakes:)
    @NSManaged public func addToTakes(_ values: NSSet)

    @objc(removeTakes:)
    @NSManaged public func removeFromTakes(_ values: NSSet)

}

extension Item : Identifiable {

}
