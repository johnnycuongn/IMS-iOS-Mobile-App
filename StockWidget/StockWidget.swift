//
//  StockWidget.swift
//  StockWidget
//
//  Created by Jeyden Johnson on 29/10/2023.
//


import WidgetKit
import SwiftUI
import Intents
import CoreData

@main
struct StockWidget: Widget {
    let kind: String = "StockWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            StockWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> StockWidgetEntry {
        let placeholderMessage = "No stock takes available"
//        let placeholderStockTake = StockTake()
//        placeholderStockTake.stock_description = placeholderMessage

        return StockWidgetEntry(date: Date(), stockTake: nil)
    }
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (StockWidgetEntry) -> ()) {
        let placeholderMessage = "No stock takes available"
//        let placeholderStockTake = StockTake()
//        placeholderStockTake.stock_description = placeholderMessage

        let entry = StockWidgetEntry(date: Date(), stockTake: nil)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<StockWidgetEntry>) -> Void) {
            var entries: [StockWidgetEntry] = []

        do {
                let stockTakes = try StockTakeModel.shared.getStockTakes()
            print("Fetched \(stockTakes.count) stock takes.")
            if stockTakes.isEmpty {
                            // If there are no stock takes, add a placeholder entry
//                            let placeholderStockTake = nil
                            let entry = StockWidgetEntry(date: Date(), stockTake: nil)
                            entries.append(entry)
                        }
            else if let mostRecentStockTake = stockTakes.first {
                    let entry = StockWidgetEntry(date: Date(), stockTake: mostRecentStockTake)
                    entries.append(entry)
                    print(entry)
                }
            } catch {
                print("Error fetching StockTakes: \(error)")
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
}

struct StockWidgetEntry: TimelineEntry {
    let date: Date
    let stockTake: StockTake?
}

struct StockWidgetEntryView : View {
    var entry: StockWidgetEntry
    
    init(entry: StockWidgetEntry) {
        self.entry = entry
        print("entry", entry)
    }

    var body: some View {
        
        if let stock = entry.stockTake, let item = stock.item {
            if stock.status == nil {
                Text("No stock takes available")
            } else {
                VStack(alignment: .leading) {
                    Text("\(item.name ?? "N/A")").font(.headline)
                    Text("\(stock.inventory_from) -> \(stock.inventory_to)")
                    Text("Status: \(stock.status ?? "")")
                    Text("Description: \(stock.stock_description ?? "")")
                }
            }
        }
//        if let stock = entry.stockTake, let status = stock.status {
//            Text("Yeah there is stock")
//            Text(String(describing: stock))
////            Text(stock.status ?? "No status")
//        } else {
//            Text("sds")
//        }
    }
}

struct StockWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        let stockTake = StockTake(context: CoreDataStorage.shared.context)
        let item = Item(context: CoreDataStorage.shared.context)
        item.inventory = 10
        item.barcode = "124"
        item.name = "Gum"
        stockTake.status = "complete"
        stockTake.inventory_from = 5
        stockTake.inventory_to = 10
        stockTake.stock_description = "13132"
        stockTake.created_at = Date()
        stockTake.updated_at = Date()
        stockTake.item = item
        CoreDataStorage.shared.saveContext()
        
        return StockWidgetEntryView(entry: StockWidgetEntry(date: Date(), stockTake: stockTake))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
