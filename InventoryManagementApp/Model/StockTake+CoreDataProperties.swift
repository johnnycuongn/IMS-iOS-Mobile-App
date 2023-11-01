//
//  StockTake+CoreDataProperties.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//
//

import Foundation
import CoreData

// extension of the Stocktake class above which adds more functionalities
extension StockTake {

    // this is a fetch request to retrieve the Stocktake entities
    @nonobjc public class func fetchRequest() -> NSFetchRequest<StockTake> {
        return NSFetchRequest<StockTake>(entityName: "StockTake")
    }

    
    @NSManaged public var status: String? //status attribute
    @NSManaged public var inventory_from: Int32 // starting inventory number
    @NSManaged public var inventory_to: Int32 // ending inventory number
    @NSManaged public var stock_description: String? // stock description
    @NSManaged public var created_at: Date? // time of when the entity was created
    @NSManaged public var updated_at: Date? // time of when the entity was last updated
    @NSManaged public var item: Item? // relationship entity

}

extension StockTake : Identifiable {

}
