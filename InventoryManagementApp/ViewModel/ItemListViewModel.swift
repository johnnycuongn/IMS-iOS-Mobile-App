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
    @Published var errorText: String  = ""
    let itemModel: ItemModel = ItemModel()
    let upcService = UPCService()
    
    func fetchItems() {
        do {
            self.items = try itemModel.getItems()
            print("ViewModel: Get items \(items)")
        } catch {
            self.errorText = "Error while fetching items: \(error)"
        }
    }
    
    func addItem(name: String, inventory: Int32, lowerLimit: Int32, barcode: String?) {
        upcService.fetchItemByUPC(barcode ?? "") { details, error in
            if let details = details {
                print("Viewmodel there is barcode \(barcode)")
                do {
                    try self.itemModel.addItem(name: name, inventory: inventory, lowerLimit: lowerLimit, barcode: barcode!)
                    self.fetchItems()
                } catch {
                    self.errorText = "Error while adding item: \(error)"
                }
                
                if let error = error {
                    self.errorText = "Invalid UPC \(String(describing: barcode))"
                }
                
            }
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
