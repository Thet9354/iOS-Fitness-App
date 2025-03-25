//
//  ChartsViewModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 25/3/25.
//

import Foundation

class ChartsViewModel: ObservableObject {
    
    var mockWeekChartData = [
        DailyStepModel(date: Date(), count: 12315),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -5, to: Date()) ?? Date(), count: 9775),
        DailyStepModel(date: Calendar.current.date(byAdding: .day, value: -6, to: Date()) ?? Date(), count: 9775),
    ]
    
    
    var mockYTDChartData = [
        MonthlyStepModel(date: Date(), count: 122315),
        MonthlyStepModel(date: Calendar.current.date(byAdding: .month, value: -1, to: Date()) ?? Date(), count: 97752),
        MonthlyStepModel(date: Calendar.current.date(byAdding: .month, value: -2, to: Date()) ?? Date(), count: 97175),
        MonthlyStepModel(date: Calendar.current.date(byAdding: .month, value: -3, to: Date()) ?? Date(), count: 97175),
        MonthlyStepModel(date: Calendar.current.date(byAdding: .month, value: -4, to: Date()) ?? Date(), count: 8372),
        MonthlyStepModel(date: Calendar.current.date(byAdding: .month, value: -5, to: Date()) ?? Date(), count: 37168),
        MonthlyStepModel(date: Calendar.current.date(byAdding: .month, value: -6, to: Date()) ?? Date(), count: 97875),
        MonthlyStepModel(date: Calendar.current.date(byAdding: .month, value: -7, to: Date()) ?? Date(), count: 97175),
    ]
    
    /// Manage mock data for three months' worth of step counts
    @Published var mockThreeMonthData = [DailyStepModel]()
    
    @Published var oneWeekAverage = 1243
    @Published var oneWeekTotal = 8223
    
    @Published var oneMonthAverage = 97175
    @Published var oneMonthTotal = 7
    
    @Published var mockOneMonthData = [DailyStepModel]()
    @Published var threeMonthAverage = 97875
    @Published var threeMonthTotal = 6
    
    @Published var ytdAverage = 97175
    @Published var ytdTotal = 4
    
    @Published var oneYearAverage = 97752
    @Published var oneYearTotal = 10
    
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
            let dailyStepData = DailyStepModel(date: currentDate, count: randomStepCount)
            
            /// Append the newly created step data to the mock data array.
            mockData.append(dailyStepData)
            
        }
        return mockData
    }

}
