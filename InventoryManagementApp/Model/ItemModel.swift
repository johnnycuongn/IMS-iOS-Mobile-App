//
//  ItemModel.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation
import CoreData

class ItemModel {
    
    static let shared = ItemModel()
    let storage: CoreDataStorage = CoreDataStorage.shared
    let stockTakeModel = StockTakeModel.shared
    
    /**
     itemModel.addItem(name: "Item 1", inventory: 50, lowerLimit: 10, barcode: "1234567890")
     */
    func addItem(name: String, inventory: Int32, lowerLimit: Int32, barcode: String) throws {
        let item = Item(context: storage.context)
        item.name = name
        item.inventory = inventory
        item.lower_limit = lowerLimit
        item.barcode = barcode
        storage.saveContext()
    }
    
    /**
            Use this one to update inventory, instead of update stock take
     */
    func updateItem(item: Item, newName: String = "", newInventory: Int32) throws {
        let oldInventory = item.inventory
            
        // Update item properties
        if (newName.trimmingCharacters(in: .whitespaces) != "" && newName != item.name) {
            item.name = newName
        }
        
        item.inventory = newInventory
        
        // Check if inventory has changed
        if oldInventory != newInventory {
            // Automatically create a stock take with status 'Complete'
            try stockTakeModel.addStockTake(status: StockTakeStatus.complete, inventoryFrom: oldInventory, inventoryTo: newInventory, description: "Automatic Stock Take for \(item.name)", item: item)
        }
        
        checkInventoryAndNotify(item: item)
        
        storage.saveContext()
    }
    
    /**
     let items = itemModel.getItems()
     if let firstItem = items.first {
         stockTakeModel.addStockTake(status: "Pending", inventoryFrom: 5, inventoryTo: 10, description: "Description", item: firstItem)
     }
     */
    func getItems() throws -> [Item]  {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let items = try storage.context.fetch(fetchRequest)
            return items
        } catch {
            print("Failed to fetch Items: \(error)")
            return []
        }
    }
    
    func removeItem(item: Item) throws {
        storage.context.delete(item)
        storage.saveContext()
    }
}
