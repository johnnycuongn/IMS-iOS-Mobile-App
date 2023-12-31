//
//  StockWidgetLiveActivity.swift
//  StockWidget
//
//  Created by Jeyden Johnson on 29/10/2023.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct StockWidgetAttributes: ActivityAttributes { // this sets the attributes of the stock widget
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct StockWidgetLiveActivity: Widget { // Live activity version of the stock widget
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: StockWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack { // This is the UI components for the banner
                Text("Hello")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("Min")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

// preview of the live activity stock widget for SwiftUI design
struct StockWidgetLiveActivity_Previews: PreviewProvider {
    static let attributes = StockWidgetAttributes(name: "Me")
    static let contentState = StockWidgetAttributes.ContentState(value: 3)

    
    // different previews for states of the widget 
    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
