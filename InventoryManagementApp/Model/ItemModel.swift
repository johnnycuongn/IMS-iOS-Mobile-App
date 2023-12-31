//
//  ItemModel.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation
import CoreData

class ItemModel { // Model class to look after the inventory items
    
    
    // Shared instances
    private var storage: CoreDataStorage = CoreDataStorage.shared
    private var stockTakeModel = StockTakeModel.shared
    
    /**
     itemModel.addItem(name: "Item 1", inventory: 50, lowerLimit: 10, barcode: "1234567890")
     */
    // function to add item , list of parameters that are needed such as name, inventory, lowerlimit, bardcode etc
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
    // update an existing item , also follows similarly with parameters such as item name, newName and newInventory
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
            stockTakeModel.addStockTake(status: StockTakeStatus.complete, inventoryFrom: oldInventory, inventoryTo: newInventory, description: "Automatic Stock Take for \(String(describing: item.name))", item: item)
        }
        
        NotificationService.shared.checkInventoryAndNotify(item: item) // to ensure and send notification if inventory is below the threshold
        
        storage.saveContext()
    }
    
    /**
     let items = itemModel.getItems()
     if let firstItem = items.first {
         stockTakeModel.addStockTake(status: "Pending", inventoryFrom: 5, inventoryTo: 10, description: "Description", item: firstItem)
     }
     */
    
    // This function will return the array of items
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
    // function to clear databsee of all items
    func removeAllItems() throws {
        let items = try getItems()  // Fetch all items
        for item in items {
            storage.context.delete(item)  // Delete each item
        }
        storage.saveContext()  // Save the context to commit the deletions
    }
    public func scheduleDailyNotification() { // daily notification function to infom users about low inventory
            do {
                let items = try self.getItems()
                var lowStockItems: [Item] = []

                for item in items { // low stock items
                    if item.inventory < 5 {
                        lowStockItems.append(item)
                    }
                }

                let title = "Daily Inventory Notification"
                var body = "Low Stock Items: "

                for item in lowStockItems {
                    body += "\(item.name ?? "N/A") (\(item.inventory))"
                }

                // This schedules the notification 
                NotificationService.shared.scheduleDailyNotification(notificationID: "daily_stocks", title: title, body: body)

            } catch {
                print(error)
            }
        }
}

