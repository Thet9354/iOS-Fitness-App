//
//  ChartOptions.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 25/3/25.
//

import Foundation

/// Represents different time range options for displaying chart data.
/// CaseIterable comformance allows easy iteration over all cases
enum ChartOptions: String, CaseIterable {
    case oneWeek = "1W"
    case oneMonth = "1M"
    case threeMonth = "3M"
    case yearToDate = "YTD"
    case oneYear = "1Y"
}
