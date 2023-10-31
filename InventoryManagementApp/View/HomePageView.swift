//
//  HomePageView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 23/10/2023.
//

import SwiftUI

struct HomePageView: View { // This is the main homepage of the Inventory Management app
    
    
    private var itemViewModel: ItemListViewModel = ItemListViewModel() // This is the view model that contains the list of items
    
    private var stockTakeViewModel: StockTakeViewModel = StockTakeViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                NavigationLink(destination: ItemListView()) {
                    Text("View Items")
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(Color.red)
                        .cornerRadius(10)
                        .shadow(color: .gray, radius: 4, x: 0, y: 4) // Shadow
                }
                Divider()
                VStack(alignment: .leading) {
                    Text("Recent Stock Take").font(.title2)
                    StockListView()
                }
            }.padding(10)
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
//tyjhh
