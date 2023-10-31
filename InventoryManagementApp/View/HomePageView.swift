//
//  HomePageView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 23/10/2023.
//

import SwiftUI

struct HomePageView: View { // This is the main homepage of the Inventory Management app
    
    
    private var itemViewModel: ItemListViewModel = ItemListViewModel() // This is the view model that contains the list of items
    
    private var stockTakeViewModel: StockTakeViewModel = StockTakeViewModel() // This view model takes care of stocktake functions
    
    var body: some View { // UI of the main homepage
        NavigationView { // Use of the navigation view
            VStack(alignment: .leading) { // Vertical stack of the views within the main page
                NavigationLink(destination: ItemListView()) {
                    Text("View Items") // This is the UI components for the view items button
                        .foregroundColor(.white) // sets text color as white
                        .padding(.horizontal, 40) //padding
                        .padding(.vertical, 10) //padding
                        .background(Color.red) //button background is red
                        .cornerRadius(10) //shadow of the button makes it pop more
                        .shadow(color: .gray, radius: 4, x: 0, y: 4) // Shadow
                }
                Divider() // THis is a divider it adds a line to divide up sections of the main page view
                VStack(alignment: .leading) {
                    Text("Recent Stock Take").font(.title2) // Vertical stack of the title in the main view page
                    StockListView() // Calling stocklist viewModel
                }
            }.padding(10)
        }
    }
}

struct HomePageView_Previews: PreviewProvider { // This is the preview which is the Homepage of the Inventory Management app 
    static var previews: some View {
        HomePageView()
    }
}
//tyjhh
