//
//  StockTakeViewModel.swift
//  InventoryManagementApp
//
//  Created by Johnny on 24/10/2023.
//

import SwiftUI//
import CoreData

class StockTakeViewModel: ObservableObject { // this handles stocktake which we used in our apps inventory system
    @Published var stockTakes: [StockTake] = [] // The stocktake list as the variable list changes
    @Published var errorText: String = "" // error handling , looks out for error messages in the view
    
    private var stockTakeModel = StockTakeModel.shared // handles data related to stock take
    
    func fetchStockTakes() {
        stockTakes = stockTakeModel.getStockTakes() // updates the array with each stocktake
    }
    
    func fetchStockTakes(for item: Item) {
        stockTakes = stockTakeModel.getStockTakes(for: item) // This only gathers data on a specifc stocktake item
    }
    // add a new stocktake file
    func addStockTake(status: StockTakeStatus, inventoryFrom: Int32, inventoryTo: Int32, description: String, item: Item) {
        do {
            stockTakeModel.addStockTake(status: status, inventoryFrom: inventoryFrom, inventoryTo: inventoryTo, description: description, item: item)
            fetchStockTakes()
        } catch {
            self.errorText = "Error while adding stock take: \(error)" // error handling
        }
    }
    // This refreshes and updates the stocktake to list the updated version to users
    func updateStockTake(stockTake: StockTake, newStatus: StockTakeStatus) {
        do {
            try stockTakeModel.updateStockTake(stockTake: stockTake, newStatus: newStatus)
            fetchStockTakes()
        } catch {
            self.errorText = "Error while updating stock take: \(error)" // error handling here again looking for error messages in the view
        }
    }
    // removes a specific stocktake entry , it is then updated to refresh and show the list where the stoctake record has been removed!
    func removeStockTake(stockTake: StockTake) {
        do {
            stockTakeModel.removeStockTake(stockTake: stockTake)
            fetchStockTakes()
        } catch {
            self.errorText = "Error while removing stock take: \(error)" // error handling 
        }
    }
}
