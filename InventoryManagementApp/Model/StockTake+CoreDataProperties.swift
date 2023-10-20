//
//  StockTake+CoreDataProperties.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//
//

import Foundation
import CoreData


extension StockTake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockTake> {
        return NSFetchRequest<StockTake>(entityName: "StockTake")
    }

    @NSManaged public var status: String?
    @NSManaged public var inventory_from: Int32
    @NSManaged public var inventory_to: Int32
    @NSManaged public var stock_description: String?
    @NSManaged public var created_at: Date?
    @NSManaged public var updated_at: Date?
    @NSManaged public var item: Item?

}

extension StockTake : Identifiable {

}
