//
//  ItemListView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 23/10/2023.
//

import SwiftUI

struct ItemCardView: View {
    let item: Item
    @ObservedObject var viewModel: ItemListViewModel

    var body: some View {
        NavigationLink(destination: ItemDetailsView(item: item, itemViewModel: viewModel)) {
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
                
//                viewModel.fetchItems()
                showModal = false
            })
        }

    }
}

struct ItemListView: View {
    
    @ObservedObject var viewModel: ItemListViewModel = ItemListViewModel()
    
    @State private var showModal = false
        

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.items, id: \.self) { item in
                        ItemCardView(item: item, viewModel: viewModel)
                    }
                }
                .padding()
            }
            .onAppear {
                print("ItemListView appear")
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

