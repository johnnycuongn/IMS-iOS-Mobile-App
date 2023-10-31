//
//  StockWidgetBundle.swift
//  StockWidget
//
//  Created by Jeyden Johnson on 29/10/2023.
//

import WidgetKit
import SwiftUI

struct StockWidgetBundle: WidgetBundle {
    var body: some Widget {
        StockWidget()
        StockWidgetLiveActivity()
    }
}
