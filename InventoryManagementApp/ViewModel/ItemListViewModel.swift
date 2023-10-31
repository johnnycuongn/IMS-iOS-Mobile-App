//
//  ItemListViewModel.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation
import SwiftUI

class ItemListViewModel: ObservableObject {
    @Published var items: [Item] = [] // This varianle runs using publishing property to update the items list when it changes
    @Published var errorText: String  = "" // This publish property only runs if there is an error aka error handling
    let itemModel: ItemModel = ItemModel() // instance of item model
    let upcService = UPCService() // Universal Product Code, gets data through UPC
    
    func fetchItems() {
        do {
            self.items = try itemModel.getItems()
            print("ViewModel: Get items \(items)")
        } catch {
            self.errorText = "Error while fetching items: \(error)" // error handling, fetches and updates errorText from above
        }
    }
    
    // This function adds a new item
    func addItem(name: String, inventory: Int32, lowerLimit: Int32, barcode: String?) {
        upcService.fetchItemByUPC(barcode ?? "") { details, error in
            if let details = details {
                print("Viewmodel there is barcode \(barcode)")
                do {
                    try self.itemModel.addItem(name: name, inventory: inventory, lowerLimit: lowerLimit, barcode: barcode!)
                    self.fetchItems()
                } catch {
                    self.errorText = "Error while adding item: \(error)" // error handling
                }
                
                if let error = error {
                    self.errorText = "Invalid UPC \(String(describing: barcode))" // error handling
                }
                
            }
        }
    }
    
    func updateItemInventory(item: Item, newInventory: Int32) { // Updates the inventory
        do {
            try self.itemModel.updateItem(item: item, newInventory: newInventory)
        } catch {
            self.errorText = "Failed to update item" // error handling
        }
    }
    
    func updateItemName(item: Item, newName: String) { // updates the item name only
        do {
            try self.itemModel.updateItem(item: item, newName: newName, newInventory: item.inventory)
        } catch {
            self.errorText = "Failed to update item name" // error handling
        }
        
    }
    // Removes a specific item within the list
    func removeItem(item: Item) {
        do {
            try itemModel.removeItem(item: item) // refreshes the list to display the updated item list to user
            fetchItems()
        } catch {
            self.errorText = "Error while removing item: \(error)" // error handling 
        }
    }
}

