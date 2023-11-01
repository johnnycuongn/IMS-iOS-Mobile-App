//
//  StockWidgetBundle.swift
//  StockWidget
//
//  Created by Jeyden Johnson on 29/10/2023.
//

import WidgetKit
import SwiftUI

struct StockWidgetBundle: WidgetBundle { // widget buddle
    var body: some Widget {
        StockWidget() // import stock widget
        StockWidgetLiveActivity() // showcases live activity of the widget 
    }
}
