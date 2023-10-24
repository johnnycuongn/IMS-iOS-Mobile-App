//
//  ItemDetailView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 24/10/2023.
//

import SwiftUI

struct ItemDetailsView: View {
    var item: Item
    @State private var upcDetails: UPCResponse.Item?
    @State private var error: Error?
    @State private var isLoading: Bool = false
    
    @State private var showInventoryUpdateView: Bool = false
    @State private var newInventory: Int32 = 0
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if isLoading {
                        ProgressView("Loading...")
                    } else {
                        Text("Item Details")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .padding(.bottom, 20)
                        
                        detailSection(title: "Item Name:", detail: "\(item.name ?? "N/A")")
                        detailSection(title: "Inventory:", detail: "\(item.inventory)")
                        detailSection(title: "Lower Limit:", detail: "\(item.lower_limit)")
                        detailSection(title: "Barcode:", detail: "\(item.barcode ?? "N/A")")
                        
                        if let details = upcDetails {
                            Divider()
                            Text("UPC Details:")
                                .font(.title2)
                                .fontWeight(.bold)
                                .padding(.top, 20)
                            
                            detailSection(title: "Brand:", detail: "\(details.brand)")
                            detailSection(title: "Title:", detail: "\(details.title)")
                            detailSection(title: "Description:", detail: "\(details.description)")
                            detailSection(title: "Color:", detail: "\(details.color)")
                        }
                    }
                }
                .padding(16)
            }
            .onAppear(perform: fetchUPCDetails)
            .navigationBarTitle("Item Details", displayMode: .inline)
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        self.newInventory = self.item.inventory  // Initialize with the current inventory
                        self.showInventoryUpdateView.toggle()
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(Color.blue)
                    }
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
            }
            
            // Inventory Update Popup
            if showInventoryUpdateView {
                ZStack {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            self.showInventoryUpdateView.toggle()
                        }
                    
                    VStack(spacing: 20) {
                        Text("Update Inventory")
                            .font(.headline)
                            .padding()
                        
                        Text("Current Inventory: \(item.inventory)")
                        Text("Lower Limit: \(item.lower_limit)")
                        
                        TextField("New Inventory", value: $newInventory, formatter: NumberFormatter())
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 24)
                        
                        HStack(spacing: 40) {
                            Button("Cancel") {
                                self.showInventoryUpdateView.toggle()
                            }
                            Button("Update") {
                                // Handle inventory update logic here
                                // Update your CoreData or whichever storage you are using
                                self.showInventoryUpdateView.toggle()
                            }
                        }
                        HStack{
                            Button(action: {
                                // Your delete action here
                            }) {
                                Text("Delete")
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.red)
                                    .cornerRadius(8)
                            }
                        }
                        .padding()
                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 24)
                }
            }
        }
    }
    
    func detailSection(title: String, detail: String) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .fontWeight(.bold)
            Text(detail)
                .foregroundColor(.gray)
        }
        .padding(.bottom, 10)
    }
    
    func fetchUPCDetails() {
        isLoading = true
        let service = UPCService()
        service.fetchItemByUPC(item.barcode ?? "") { details, error in
            isLoading = false
            self.upcDetails = details
            self.error = error
        }
    }
}

struct ItemDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let item = Item(context: CoreDataStorage.shared.context)
        item.name = "Hello"
        item.inventory = 0
        item.barcode = "99555085273"
        return ItemDetailsView(item: item)
    }
}