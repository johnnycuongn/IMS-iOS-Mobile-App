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
        let placeholderStockTake = StockTake()
        placeholderStockTake.stock_description = placeholderMessage

        return StockWidgetEntry(date: Date(), stockTake: placeholderStockTake)
    }
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (StockWidgetEntry) -> ()) {
        let placeholderMessage = "No stock takes available"
        let placeholderStockTake = StockTake()
        placeholderStockTake.stock_description = placeholderMessage

        let entry = StockWidgetEntry(date: Date(), stockTake: placeholderStockTake)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<StockWidgetEntry>) -> Void) {
            var entries: [StockWidgetEntry] = []

        do {
                let stockTakes = try StockTakeModel.shared.getStockTakes()
            print("Fetched \(stockTakes.count) stock takes.")
            if stockTakes.isEmpty {
                            // If there are no stock takes, add a placeholder entry
                            let placeholderStockTake = StockTake()
                            let entry = StockWidgetEntry(date: Date(), stockTake: placeholderStockTake)
                            entries.append(entry)
                        }
                if let mostRecentStockTake = stockTakes.first {
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
    let stockTake: StockTake
}

struct StockWidgetEntryView : View {
    var entry: StockWidgetEntry

    var body: some View {
        
        if entry.stockTake.status == nil {
                    Text("No stock takes available")
        } else {
            VStack {
                Text("Most Recent StockTake")
                    .font(.headline)
                Text("Status: \(entry.stockTake.status ?? "")")
                Text("Description: \(entry.stockTake.stock_description ?? "")")
            }
        }
    }
}

struct StockWidget_Previews: PreviewProvider {
    static var previews: some View {
        let placeholderStockTake = StockTake()
        StockWidgetEntryView(entry: StockWidgetEntry(date: Date(), stockTake: placeholderStockTake))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
