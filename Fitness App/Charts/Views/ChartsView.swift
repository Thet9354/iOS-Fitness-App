//
//  HistoricDataView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 15/3/25.
//

import SwiftUI
import Charts

struct ChartsView: View {
    
    // MARK: VARIABLES
    /// ViewModel responsible for handling chart data
    @StateObject var viewModel = ChartsViewModel()
    /// Selected chart option for displaying different time ranges
    @State var selectedChart: ChartOptions = .oneWeek
    
    var body: some View {
        VStack {
            /// Title for the charts view
            Text("Charts")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            /// Chart display area
            ZStack {
                switch selectedChart {
                case .oneWeek:
                    VStack {
                        /// Displays average and total steps for one week
                        ChartDataView(average: viewModel.oneWeekAverage, total: viewModel.oneWeekTotal)
                        
                        // Bar chart visualisation for weekly step data
                        Chart {
                            ForEach(viewModel.mockWeekChartData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                            }
                        }
                    }
                case .oneMonth:
                    VStack {
                        /// Displays average and total steps for one month
                        ChartDataView(average: viewModel.oneMonthTotal, total: viewModel.oneMonthTotal)
                        
                        /// Bar chart visualisation for monthly step data
                        Chart {
                            ForEach(viewModel.mockOneMonthData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                            }
                        }
                    }
                case .threeMonth:
                    VStack {
                        /// Displays average ad tital steps for three months
                        ChartDataView(average: viewModel.threeMonthAverage, total: viewModel.threeMonthTotal)
                        
                        Chart {
                            /// Barchart visualisation for three-month step data
                            ForEach(viewModel.mockThreeMonthData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                            }
                        }
                    }
                case .yearToDate:
                    VStack {
                        /// Displays average and total steps for the year-to-date period
                        ChartDataView(average: viewModel.ytdAverage, total: viewModel.ytdTotal)
                        
                        /// Bar chart visualisation for YTD step data
                        Chart {
                            ForEach(viewModel.ytdChartData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .month), y: .value("Steps", data.count))
                            }
                        }
                    }
                case .oneYear:
                    VStack {
                        /// Displays average and total steps for one year
                        ChartDataView(average: viewModel.oneYearAverage, total: viewModel.oneYearTotal)
                        
                        /// Bar chart visualisation for yearly step data
                        Chart {
                            ForEach(viewModel.oneYearChartData) { data in
                                BarMark(x: .value(data.date.formatted(), data.date, unit: .day), y: .value("Steps", data.count))
                            }
                        }
                    }
                }
            }
            .foregroundColor(.green)
            .frame(maxHeight: 450)
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
