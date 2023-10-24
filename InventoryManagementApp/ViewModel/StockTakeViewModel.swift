//
//  StockTakeViewModel.swift
//  InventoryManagementApp
//
//  Created by Johnny on 24/10/2023.
//

import SwiftUI
import CoreData

class StockTakeViewModel: ObservableObject {
    @Published var stockTakes: [StockTake] = []
    @Published var errorText: String = ""
    
    private var stockTakeModel = StockTakeModel.shared
    
    func fetchStockTakes() {
        stockTakes = stockTakeModel.getStockTakes()
    }
    
    func fetchStockTakes(for item: Item) {
        stockTakes = stockTakeModel.getStockTakes(for: item)
    }
    
    func addStockTake(status: StockTakeStatus, inventoryFrom: Int32, inventoryTo: Int32, description: String, item: Item) {
        do {
            stockTakeModel.addStockTake(status: status, inventoryFrom: inventoryFrom, inventoryTo: inventoryTo, description: description, item: item)
            fetchStockTakes()
        } catch {
            self.errorText = "Error while adding stock take: \(error)"
        }
    }
    
    func updateStockTake(stockTake: StockTake, newStatus: StockTakeStatus) {
        do {
            try stockTakeModel.updateStockTake(stockTake: stockTake, newStatus: newStatus)
            fetchStockTakes()
        } catch {
            self.errorText = "Error while updating stock take: \(error)"
        }
    }
    
    func removeStockTake(stockTake: StockTake) {
        do {
            stockTakeModel.removeStockTake(stockTake: stockTake)
            fetchStockTakes()
        } catch {
            self.errorText = "Error while removing stock take: \(error)"
        }
    }
}
