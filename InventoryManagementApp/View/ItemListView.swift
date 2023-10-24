//
//  ItemListView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 23/10/2023.
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
                        Image(systemName: "plus.circle.fill")
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

struct ItemCardView: View {
    let item: Item

    var body: some View {
        NavigationLink(destination: ItemDetailsView(item: item)) {
            VStack(alignment: .leading) {
                Text(item.name ?? "Unknown")
                    .font(.headline)
                Text("Inventory: \(item.inventory)")
                Text("Lower Limit: \(item.lower_limit)")
                Text("Barcode: \(item.barcode ?? "N/A")")
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9, alignment: .leading)
            .padding()
            .background(Color(.systemGray5))
            .cornerRadius(8)
        }
    }
}

struct AddItemView: View {
    @Binding var showModal: Bool
    @ObservedObject var viewModel: ItemListViewModel
    
    var itemToEdit: Item?
    
    @State private var name: String = ""
    @State private var inventory: Int32 = 0
    @State private var lowerLimit: Int32 = 0
    @State private var barcode: String = ""
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                VStack(alignment: .leading) {
                    Text("Item Name")
                    TextField("Item Name", text: $name)
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("Inventory")
                    TextField("Inventory", value: $inventory, formatter: NumberFormatter())
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("Lower Limit")
                    TextField("Lower Limit", value: $lowerLimit, formatter: NumberFormatter())
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("Barcode")
                    TextField("Barcode", text: $barcode)
                }
                .padding(.bottom, 20)
            }
            .padding()
            .navigationBarTitle(itemToEdit == nil ? "Add Item" : "Edit Item", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                showModal = false
            }, trailing: Button("Save") {
                if let itemToEdit = itemToEdit {
                    //
                } else {
                    viewModel.addItem(name: name, inventory: inventory, lowerLimit: lowerLimit, barcode: barcode)
                }
            
                showModal = false
            })
        }

    }
}

struct ItemListView: View {
    
    @ObservedObject var viewModel: ItemListViewModel = ItemListViewModel()
    
    @State private var showModal = false
        

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        ForEach(viewModel.items, id: \.self) { item in
                            ItemCardView(item: item)
                        }
                    }
                    .padding()
                }
                .onAppear {
                    viewModel.fetchItems()
                }
                .alert(isPresented: Binding<Bool>.constant(viewModel.errorText != ""), content: {
                    Alert(title: Text("Error"), message: Text(viewModel.errorText ?? "Unknown error"), dismissButton: .default(Text("OK")))
                })
                
                Button(action: {
                    showModal.toggle()
                }) {
                    Text("+")
                        .font(.system(.largeTitle))
                        .frame(width: 67, height: 60)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 7)
                }
                .background(Color.blue)
                .cornerRadius(38.5)
                .padding()
                .shadow(color: Color.black.opacity(0.3),
                        radius: 3,
                        x: 3,
                        y: 3)
                .sheet(isPresented: $showModal) {
                    AddItemView(showModal: $showModal, viewModel: viewModel)
                }
            }
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        let model = ItemModel()
        let viewModel = ItemListViewModel()
        do {
            try model.removeAllItems()
        } catch {
            print(error)
        }
        
        viewModel.addItem(name: "2", inventory: 2, lowerLimit: 2, barcode: "99555085273")
        return ItemListView(viewModel: viewModel)
    }
}
