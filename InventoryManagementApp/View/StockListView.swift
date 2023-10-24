//
//  StockListView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 24/10/2023.
//

import SwiftUI

struct StockListView: View {
    
    @ObservedObject var viewModel: StockTakeViewModel = StockTakeViewModel()
    @State private var showModal = false
    
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
                .onAppear {
                    viewModel.fetchStockTakes()
                }
                .alert(isPresented: Binding<Bool>.constant(viewModel.errorText != ""), content: {
                    Alert(title: Text("Error"), message: Text(viewModel.errorText ?? "Unknown error"), dismissButton: .default(Text("OK")))
                })
            }
        }
    }
}

struct StockTakeCardView: View {
    let stocktake: StockTake

    var body: some View {
        VStack(alignment: .leading) {
            Text(stocktake.item?.name ?? "Unknown")
                .font(.headline)
            Text("Inventory from \(stocktake.inventory_from) -> \(stocktake.inventory_to)")
            Text("\(stocktake.status ?? "None")")


        }
        .frame(maxWidth: UIScreen.main.bounds.width * 0.9, alignment: .leading)
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(8)
    }
}



struct StockListView_Previews: PreviewProvider {
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
            print(error)
        }
       
        return StockListView(viewModel: viewModel)
    }
}
