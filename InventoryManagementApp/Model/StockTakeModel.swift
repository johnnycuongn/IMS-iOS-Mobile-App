//
//  StockTakeModel.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation
import CoreData

 
// This shows the different status stocktake can have
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


    // This class to manage stock take
public class StockTakeModel {
    
    static let shared: StockTakeModel = StockTakeModel() // This is a shared instance
    
    let storage: CoreDataStorage = CoreDataStorage.shared // Instance of CoreDataStorage to perform CRUD operations!
    
    
    // This function is here to add stock take
    func addStockTake(status: StockTakeStatus, inventoryFrom: Int32, inventoryTo: Int32, description: String, item: Item) {
        let stockTake = StockTake(context: storage.context)
        stockTake.status = status.stringValue()
        stockTake.inventory_from = inventoryFrom
        stockTake.inventory_to = inventoryTo
        stockTake.stock_description = description
        stockTake.created_at = Date() // This sets the current date as the creation date
        stockTake.updated_at = Date()
        stockTake.item = item
        storage.saveContext()
    }
 
    // function to update the status of stock take
    func updateStockTake(stockTake: StockTake, newStatus: StockTakeStatus) throws {
        if let oldStatusString = stockTake.status,
           let oldStatus = StockTakeStatus.from(string: oldStatusString),
           oldStatus == .pending && newStatus == .complete {
           
            // Update item inventory if the stocktake status switches from pending to complete
            if let item = stockTake.item {
                item.inventory = stockTake.inventory_to
            }
        }
        stockTake.status = newStatus.stringValue()
        stockTake.updated_at = Date() // update the timestamp
        storage.saveContext()
        
    }
    // this function to fetch all stocktake
    public func getStockTakes() -> [StockTake] {
        let fetchRequest: NSFetchRequest<StockTake> = StockTake.fetchRequest()
        
        // Sort by updated_at fields that goes in descending order
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
        
        do {
            let stockTakes = try storage.context.fetch(fetchRequest)
            return stockTakes
        } catch {
            print("Failed to fetch StockTakes: \(error)") // error handling
            return []
        }
    }
    
    public func getStockTakes(completion: @escaping ([StockTake]) -> Void) {
        let fetchRequest: NSFetchRequest<StockTake> = StockTake.fetchRequest()
        
        // Sort by updated_at
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
        
        do {
            let stockTakes = try storage.context.fetch(fetchRequest)
            completion(stockTakes)
        } catch {
            print("Failed to fetch StockTakes: \(error)")
            completion([])
        }
    }
    
    // removes a specific stocktake
    func removeStockTake(stockTake: StockTake) {
        storage.context.delete(stockTake)
        storage.saveContext()
    }
    // This fetches the stocktake for a specific item in item list
    public func getStockTakes(for item: Item) -> [StockTake] {
        let fetchRequest: NSFetchRequest<StockTake> = StockTake.fetchRequest()
        
        // Add a predicate to filter stock takes for the specific item
        fetchRequest.predicate = NSPredicate(format: "item == %@", item)
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "updated_at", ascending: false)]
        
        do {
            let stockTakes = try storage.context.fetch(fetchRequest)
            return stockTakes
        } catch {
            print("Failed to fetch StockTakes for item: \(error)") // error handling
            return []
        }
    }
    // Function to remove all stock take
    func removeAll() throws {
        let items = try getStockTakes()  // Fetch all items
        for item in items {
            storage.context.delete(item)  // Delete each item
        }
        storage.saveContext()  // Save the changes
    }
}
