//
//  StockListView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 24/10/2023.
//

import SwiftUI

struct StockListView: View {
    
    @ObservedObject var viewModel: StockTakeViewModel = StockTakeViewModel()  //This viewmodel holds the stocktake data and is an observed object to be viewed by all files
    @State private var showModal = false// This state variable showModel is what ensures that the overlays are being presented
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.stockTakes, id: \.self) { item in StockTakeCardView(stocktake: item)
                        }
                    }
                    .padding()
                }
                .onAppear { // This ensures the fetchStockTakes function below is run when this view pop's up
                    viewModel.fetchStockTakes() // fetch stocktake data
                }
                .alert(isPresented: Binding<Bool>.constant(viewModel.errorText != ""), content: {
                    Alert(title: Text("Error"), message: Text(viewModel.errorText ?? "Unknown error"), dismissButton: .default(Text("OK"))) // error handling , displays alert messages if there is an error in this view model
                })
            }
        }
    }
}

struct StockTakeCardView: View { // This is for each stocktake
    let stocktake: StockTake

    var body: some View {
        VStack(alignment: .leading) {
            Text(stocktake.item?.name ?? "Unknown") // display item name
                .font(.headline)
            Text("Inventory from \(stocktake.inventory_from) -> \(stocktake.inventory_to)")
            Text("\(stocktake.status ?? "None")") // displays any changes in inventory, showcasing both starting and ending value  and status


        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.9, alignment: .leading)
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(8)
    }
}



struct StockListView_Previews: PreviewProvider { // Preview
    static var previews: some View {
        let stockModel = StockTakeModel.shared
        let viewModel = StockTakeViewModel()
        let itemModel = ItemModel()
        do {
            try stockModel.removeAll()
            let items = try itemModel.getItems()
            if let firstItem = items.first {
                viewModel.addStockTake(status: .pending, inventoryFrom: 5, inventoryTo: 10, description: "Description", item: firstItem)
            }
        } catch {
            print(error) // error handling 
        }
       
        return StockListView(viewModel: viewModel)
    }
}
