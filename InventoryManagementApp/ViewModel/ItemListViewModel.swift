//
//  ItemListViewModel.swift
//  InventoryManagementApp
//
//  Created by Johnny on 20/10/2023.
//

import Foundation
import SwiftUI

class ItemListViewModel: ObservableObject {
    @Published var items: [Item] = []
    @Published var errorText: String?  // Holds error message
    let itemModel: ItemModel
    
    init(itemModel: ItemModel) {
        self.itemModel = itemModel
        do {
            self.items = try itemModel.getItems()
        } catch {
            self.errorText = "Error while fetching items: \(error)"
        }
    }
    
    func fetchItems() {
        do {
            self.items = try itemModel.getItems()
        } catch {
            self.errorText = "Error while fetching items: \(error)"
        }
    }
    
    func addItem(name: String, inventory: Int32, lowerLimit: Int32, barcode: String?) {
        do {
            try itemModel.addItem(name: name, inventory: inventory, lowerLimit: lowerLimit, barcode: barcode ?? "")
            fetchItems()
        } catch {
            self.errorText = "Error while adding item: \(error)"
        }
    }
    
    func removeItem(item: Item) {
        do {
            try itemModel.removeItem(item: item)
            fetchItems()
        } catch {
            self.errorText = "Error while removing item: \(error)"
        }
    }
}
