//
//  HomePageView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 23/10/2023.
//

import SwiftUI

struct HomePageView: View {
    
    private var itemViewModel: ItemListViewModel = ItemListViewModel()
    private var stockTakeViewModel: StockTakeViewModel = StockTakeViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: ItemListView()) {
                    Button("View Items") {
                        print("View list")
                    }
                }
                VStack {
                    ScrollView {
                        
                    }
                }
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
