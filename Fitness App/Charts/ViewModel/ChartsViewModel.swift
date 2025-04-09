//
//  ChartsViewModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 25/3/25.
//

import Foundation

class ChartsViewModel: ObservableObject {
    
    /// Manage mock data for three months' worth of step counts
    @Published var oneWeekChartData = [DailyStepModel]()
    @Published var oneWeekAverage = 0
    @Published var oneWeekTotal = 0
    
    @Published var oneMonthChartData = [DailyStepModel]()
    @Published var oneMonthAverage = 0
    @Published var oneMonthTotal = 0
    
    @Published var threeMonthsChartData = [DailyStepModel]()
    @Published var threeMonthAverage = 0
    @Published var threeMonthTotal = 0
    
    @Published var ytdChartData = [MonthlyStepModel]()
    @Published var ytdAverage = 0
    @Published var ytdTotal = 0
    
    @Published var oneYearChartData = [MonthlyStepModel]()
    @Published var oneYearAverage = 0
    @Published var oneYearTotal = 0
    
    let healthManager = HealthManager.shared
    
    @Published var presentError = false
    
    /// Initializes the mock data with random step counts for the past 90 days.
    init() {
    
        Task {
            do {
                async let oneWeek: () = try await fetchOneWeekStepData()
                async let oneMonth: () =  try await fetchOneMonthStepData()
                async let threeMonths: () = try await fetchThreeMonthsStepData()
                async let ytdAndOneYear: () = try await fetchYTDAndOneYearData()
                
                _ = (try await oneWeek, try await oneMonth, try await threeMonths, try await ytdAndOneYear)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    self.presentError = true
                }
            }
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
    
    func calculateAverageAndTotalFromData(steps: [DailyStepModel]) -> (Int, Int) {
        let total = steps.reduce(0, {$0 + $1.count })
        let average = total / steps.count
        
        return (total, average)
    }
    
    func fetchOneWeekStepData() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchDailySteps(startDate: .oneWeekAgo) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let steps):
                    DispatchQueue.main.async {
                        self.oneWeekChartData = steps
                        
                        (self.oneWeekTotal, self.oneWeekAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    func fetchOneMonthStepData() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchDailySteps(startDate: .oneMonthAgo) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let steps):
                    DispatchQueue.main.async {
                        self.oneMonthChartData = steps
                        
                        (self.oneMonthTotal, self.oneMonthAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    
    func fetchThreeMonthsStepData() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchDailySteps(startDate: .threeMonthsAgo) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let steps):
                    DispatchQueue.main.async {
                        self.threeMonthsChartData = steps
                        
                        (self.threeMonthTotal, self.threeMonthAverage) = self.calculateAverageAndTotalFromData(steps: steps)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    func fetchYTDAndOneYearData() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchYTDAndOneYearChartData { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let result):
                    DispatchQueue.main.async {
                        self.ytdChartData = result.ytd
                        self.oneYearChartData = result.oneYear
                        
                        self.ytdTotal = self.ytdChartData.reduce(0, { $0 + $1.count })
                        self.oneYearTotal = self.oneYearChartData.reduce(0, { $0 + $1.count })
                        
                        self.ytdAverage = self.ytdTotal / Calendar.current.component(.month, from: Date())
                        self.oneYearAverage = self.oneYearTotal / 12
                        
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
}
