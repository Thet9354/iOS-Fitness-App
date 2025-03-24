//
//  HistoricDataView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 15/3/25.
//

import SwiftUI
import Charts

struct DailyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Double
}

/// Represents different time range options for displaying chart data.
/// CaseIterable comformance allows easy iteration over all cases
enum ChartOptions: String, CaseIterable {
    case oneWeek = "1W"
    case oneMonth = "1M"
    case threeMonth = "3M"
    case yearToDate = "YTD"
    case oneYear = "1Y"
}

class ChartsViewModel: ObservableObject {
    
    var mockChartData = [
        DailyStepModel(date: Date(), count: 12315),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(), count: 9775),
    ]
    
    @Published var mockOneMonthData = [DailyStepModel]()
    /// Manage mock data for three months' worth of step counts
    @Published var mockThreeMonthData = [DailyStepModel]()
    
    /// Initializes the mock data with random step counts for the past 90 days.
    init() {
        
        var mockOneMonth = mockDataForDays(days: 30)
        var mockThreeMonths = self.mockDataForDays(days: 90)
        DispatchQueue.main.async {
            self.mockOneMonthData = mockOneMonth
            self.mockThreeMonthData = mockThreeMonths
        }
    }
    
    func mockDataForDays(days: Int) -> [DailyStepModel] {
        var mockData = [DailyStepModel]() /// Temporary array to store the genrated mock data
        
        for day in 0..<days { /// Loops through the past 90 days (representing 3 months)
            
            /// Calendar.current: Gets current system calendar
            /// .date(byAdding: .day, value: -day, to: Date()): This modifies a given Date by adding or subtracting a specific number of days.
            /// byAdding: .day: We are modifying the day component of the date.
            /// value: -day: -day means we are subtracting day number of days from the current date.
            /// If day = 0, it gives today’s date.
            /// If day = 1, it gives yesterday’s date.
            /// If day = 2, it gives two days ago, and so on.
            /// to: Date(): This specifies the starting point, which is the current date and time (Date()).
            /// ?? Date(): If the .date(byAdding:) function somehow fails (though it rarely does), it will return the current date (Date()) as a backup.
            let currentDate = Calendar.current.date(byAdding: .day, value: -day, to: Date()) ?? Date()
            
            let randomStepCount = Int.random(in: 500...15000) // Generating a random step count between 5000 and 15000
            
            /// Create a `DailyStepModel` object with the generated date and step count.
            let dailyStepData = DailyStepModel(date: currentDate, count: Double(randomStepCount))
            
            /// Append the newly created step data to the mock data array.
            mockData.append(dailyStepData)
            
        }
        return mockData
    }

}

struct ChartsView: View {
    
    // MARK: VARIABLES
    @StateObject var viewModel = ChartsViewModel()
    @State var selectedChart: ChartOptions = .oneWeek
    
    var body: some View {
        VStack {
            Text("Charts")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            ZStack {
                switch selectedChart {
                case .oneWeek:
                    Chart {
                        ForEach(viewModel.mockChartData) { data in
                            BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                        }
                    }
                case .oneMonth:
                    Chart {
                        ForEach(viewModel.mockOneMonthData) { data in
                            BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                        }
                    }
                case .threeMonth:
                    Chart {
                        ForEach(viewModel.mockThreeMonthData) { data in
                            BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                        }
                    }
                case .yearToDate:
                    EmptyView()
                case .oneYear:
                    Chart {
                        ForEach(viewModel.mockChartData) { data in
                            BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                        }
                    }
                }
            }
            .foregroundColor(.green)
            .frame(maxHeight: 350)
            .padding(.horizontal)
            
            HStack {
                ForEach(ChartOptions.allCases, id: \.rawValue) { option in
                    Button(option.rawValue) {
                        withAnimation {
                            selectedChart = option
                        }
                    }
                    .padding()
                    .foregroundColor(selectedChart == option ? .white : .green)
                    .background(selectedChart == option ? .green : .clear)
                    .cornerRadius(10)
                }
            }
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    ChartsView()
}
