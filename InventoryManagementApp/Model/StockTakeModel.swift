//
//  StockTakeModel.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation
import CoreData

class StockTakeModel {
    
    let storage: CoreDataStorage = CoreDataStorage.shared
    
    func addStockTake(status: String, inventoryFrom: Int32, inventoryTo: Int32, description: String, item: Item) {
        let stockTake = StockTake(context: storage.context)
        stockTake.status = status
        stockTake.inventory_from = inventoryFrom
        stockTake.inventory_to = inventoryTo
        stockTake.stock_description = description
        stockTake.created_at = Date()
        stockTake.updated_at = Date()
        stockTake.item = item
        storage.saveContext()
    }
    
    func updateStockTake(stockTake: StockTake, newStatus: String) {
        stockTake.status = newStatus
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
}
