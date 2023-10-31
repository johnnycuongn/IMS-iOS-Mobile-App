//
//  ItemListView.swift
//  InventoryManagementApp
//
//  Created by Johnny on 23/10/2023.
//

import SwiftUI

struct ItemCardView: View { // This creates a view for the item card
    let item: Item // constant item which is the item to be displayed
    @ObservedObject var viewModel: ItemListViewModel // Observed object that observes changes being made in this ItemListViewModel , it contains item data

    var body: some View {
        NavigationLink(destination: ItemDetailsView(item: item, itemViewModel: viewModel)) {
            VStack(alignment: .leading) { // displays item name, if name is not known, it will print out unknown
                Text(item.name ?? "Unknown")
                    .font(.headline)
                Text("Inventory: \(item.inventory)") // display of current inventory
                Text("Lower Limit: \(item.lower_limit)") // display of lower limit of the item
                Text("Barcode: \(item.barcode ?? "N/A")") // displays the barcode of the item
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.9, alignment: .leading) // max width of the VStack - UI design presets
            .padding()
            .background(Color(.systemGray5)) // background color set to gray
            .cornerRadius(8)// how round the card  corners are - UI design elements here
            
        }
    }
}
// This is the view that pop's up for  when users want to edit an item
struct AddItemView: View {
    @Binding var showModal: Bool
    @ObservedObject var viewModel: ItemListViewModel
    
    var itemToEdit: Item? // If an item's info has been edited it will be stored in this variable
    // The following are state variable to capture user input
    @State private var name: String = ""
    @State private var inventory: Int32 = 0
    @State private var lowerLimit: Int32 = 0
    @State private var barcode: String = ""
    
    var body: some View {
        NavigationView { // Navigation view for Item list
            VStack(alignment: .leading) {
                VStack(alignment: .leading) { // This Vstack displays the item card
                    Text("Item Name")
                    TextField("Item Name", text: $name)
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("Inventory") // item inventory
                    TextField("Inventory", value: $inventory, formatter: NumberFormatter())
                }
                .padding(.bottom, 20)
                
                VStack(alignment: .leading) {
                    Text("Lower Limit") // disply text lower limit
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
            .navigationBarTitle(itemToEdit == nil ? "Add Item" : "Edit Item", displayMode: .inline) // This sets the title for the navigaiton bar , if the itemToEdit is been set to nil then the app stays in Add function. If changes are made it will switch to Edit function
            
            .navigationBarItems(leading: Button("Cancel") { // Adding a cancel button to the edit item function
                showModal = false
            }, trailing: Button("Save") { // save button to the edit item function
                if let itemToEdit = itemToEdit {
                    // update the edits made to the item
                } else {
                    viewModel.addItem(name: name, inventory: inventory, lowerLimit: lowerLimit, barcode: barcode) // Add the new item
                }
                
  //           viewModel.fetchItems()
                showModal = false // dismisses the modal
            })
        }

    }
}

struct ItemListView: View { // This is the view that displays the list of items
    
    @ObservedObject var viewModel: ItemListViewModel = ItemListViewModel() // This controls the fetch functions of the item
    
    @State private var showModal = false // We use a state variable so we can chose when to show and hide the edit and add overlays
        

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView { // Added scrollable view so users can scroll through item list
                VStack(alignment: .leading, spacing: 16) {
                    ForEach(viewModel.items, id: \.self) { item in // displays all items through loop
                        ItemCardView(item: item, viewModel: viewModel)
                    }
                }
                .padding()
            }
            .onAppear { // Items are omly fetched when the view is appearing /on
                print("ItemListView appear")
                viewModel.fetchItems()
            }
            .alert(isPresented: Binding<Bool>.constant(viewModel.errorText != ""), content: { // alert function that dislay user errors
                Alert(title: Text("Error"), message: Text(viewModel.errorText ?? "Unknown error"), dismissButton: .default(Text("OK")))
            })
            
            Button(action: {
                showModal.toggle()
            }) {
                Text("+") // Add new item button
                    .font(.system(.largeTitle)) // UI style
                    .frame(width: 67, height: 60)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 7)
            }
            .background(Color.blue) // UI style
            .cornerRadius(38.5)
            .padding()
            .shadow(color: Color.black.opacity(0.3),
                    radius: 3,
                    x: 3,
                    y: 3)
            .sheet(isPresented: $showModal) { // This presents the overlay for the edit and add views
                
                AddItemView(showModal: $showModal, viewModel: viewModel)
            }
        }
    }
}

struct ItemListView_Previews: PreviewProvider { // This is the preview for the ItemListview
    static var previews: some View {
        let model = ItemModel()
        let viewModel = ItemListViewModel() // removes items from the overlay
        do {
            try model.removeAllItems()
        } catch {
            print(error) // error handling
        }
        
        viewModel.addItem(name: "2", inventory: 2, lowerLimit: 2, barcode: "99555085273") // sample item just for testing and preview
        return ItemListView(viewModel: viewModel) // returns the example preview 
    }
}

