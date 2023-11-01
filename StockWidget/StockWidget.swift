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
            StockWidgetEntryView(entry: entry).environment(\.managedObjectContext, CoreDataStorage.shared.context)
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
        let stockTakes = StockTakeModel.shared.getStockTakes()
        
        var entry = StockWidgetEntry(date: Date(), stockTake: nil)
        
        if let firstStock = stockTakes.first {
            entry = StockWidgetEntry(date: Date(), stockTake: firstStock)
        }

        
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<StockWidgetEntry>) -> Void) {
            var entries: [StockWidgetEntry] = []

        let stockTakes = StockTakeModel().getStockTakes { stockTakes in
            for stock in stockTakes {
                let entry = StockWidgetEntry(date: Date(), stockTake: stock)
                entries.append(entry)
            }

            let timeline = Timeline(entries: entries, policy: .atEnd)
            completion(timeline)
        }
        
    }
}

struct StockWidgetEntry: TimelineEntry {
    let date: Date
    let stockTake: StockTake?
}

struct StockWidgetEntryView : View {
    var entry: StockWidgetEntry
    
//    @FetchRequest (sortDescriptors: [])
//    private var stocks: FetchedResults<StockTake>
    
    init(entry: StockWidgetEntry) {
        self.entry = entry
        print("entry", entry)
    }

    var body: some View {
        
        if let stock = entry.stockTake, let item = stock.item {
//            Text("\(stocks.count)")
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
        } else {
            Text("No stock data available")
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
