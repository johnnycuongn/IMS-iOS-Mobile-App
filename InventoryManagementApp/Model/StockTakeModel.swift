//
//  StockTakeModel.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation
import CoreData

enum StockTakeStatus: String {
    case pending = "Pending"
    case complete = "Complete"
    case canceled = "Canceled"
    
    // Convert a StockTakeStatus enum to String
    func stringValue() -> String {
        return self.rawValue
    }
    
    // Create a StockTakeStatus enum from String
    static func from(string: String) -> StockTakeStatus? {
        return StockTakeStatus(rawValue: string)
    }
}

class StockTakeModel {
    
    static let shared: StockTakeModel = StockTakeModel()
    
    let storage: CoreDataStorage = CoreDataStorage.shared
    
    func addStockTake(status: StockTakeStatus, inventoryFrom: Int32, inventoryTo: Int32, description: String, item: Item) {
        let stockTake = StockTake(context: storage.context)
        stockTake.status = status.stringValue()
        stockTake.inventory_from = inventoryFrom
        stockTake.inventory_to = inventoryTo
        stockTake.stock_description = description
        stockTake.created_at = Date()
        stockTake.updated_at = Date()
        stockTake.item = item
        storage.saveContext()
    }
 
    func updateStockTake(stockTake: StockTake, newStatus: StockTakeStatus) throws {
        if let oldStatusString = stockTake.status,
           let oldStatus = StockTakeStatus.from(string: oldStatusString),
           oldStatus == .pending && newStatus == .complete {
           
            // Update item inventory
            if let item = stockTake.item {
                item.inventory = stockTake.inventory_to
            }
        }
        stockTake.status = newStatus.stringValue()
        stockTake.updated_at = Date()
        storage.saveContext()
        
    }
    
    func getStockTakes() -> [StockTake] {
        let fetchRequest: NSFetchRequest<StockTake> = StockTake.fetchRequest()
        
        // Sort by updated_at
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
        
        do {
            let stockTakes = try storage.context.fetch(fetchRequest)
            return stockTakes
        } catch {
            print("Failed to fetch StockTakes: \(error)")
            return []
        }
    }
    
    func removeStockTake(stockTake: StockTake) {
        storage.context.delete(stockTake)
        storage.saveContext()
    }
    
    func getStockTakes(for item: Item) -> [StockTake] {
        let fetchRequest: NSFetchRequest<StockTake> = StockTake.fetchRequest()
        
        // Add a predicate to filter stock takes for the specific item
        fetchRequest.predicate = NSPredicate(format: "item == %@", item)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
        
        do {
            let stockTakes = try storage.context.fetch(fetchRequest)
            return stockTakes
        } catch {
            print("Failed to fetch StockTakes for item: \(error)")
            return []
        }
    }
    
    func removeAll() throws {
        let items = try getStockTakes()  // Fetch all items
        for item in items {
            storage.context.delete(item)  // Delete each item
        }
        storage.saveContext()  // Save th
    }
}
