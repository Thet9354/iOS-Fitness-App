//
//  HealthManager.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 16/3/25.
//

import Foundation
import HealthKit

/// Singleton class to manage HealthKit-related functionalities
class HealthManager {
    
    /// Shared instance of `HealthManager` for singleton usage
    static let shared = HealthManager()
    
    /// HealthKit store instance to interact with Health data
    let healthStore = HKHealthStore()
    
    /// Private initializer to prevent multiple instances of `HealthManager`
    private init() {
        // Request authorization to read HealthKit data
        Task {
            do {
                try await requestHealthKitAccess()
            } catch {
                DispatchQueue.main.async {
                    presentAlert(title: "Oops", message: "We were unable to access health data. Please allow access to enjoy the app.")
                }
            }
        }
    }
    
    /// Requests authorization for HealthKit data access
    func requestHealthKitAccess() async throws {
        let calories = HKQuantityType(.activeEnergyBurned)
        let exercise = HKQuantityType(.appleExerciseTime)
        let stand = HKCategoryType(.appleStandHour)
        let steps = HKQuantityType(.stepCount)
        let workouts = HKSampleType.workoutType()
        
        let healthType: Set = [calories, exercise, stand, steps, workouts]
        try await healthStore.requestAuthorization(toShare: [], read: healthType)

    }
    
    /// Fetches the total calories burned for the current day
    /// - Parameter completion: A closure that returns a `Result` containing either the total calories burned (Double) or an `Error`
    func fetchTodayCaloriesBurned(completion: @escaping(Result<Double, Error>) -> Void) {
        let calories = HKQuantityType(.activeEnergyBurned)
        
        // Create a predicate to filter samples for today
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        // Create a statistics query to sum up the calorie values
        let query = HKStatisticsQuery(quantityType: calories, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
            
            // Convert HealthKit quantity to kilocalories (kcal)
            let caloriesCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(caloriesCount))
        }
        
        // Execute the HealthKit query
        healthStore.execute(query)
    }
    
    /// Fetches the total exercise time for the current day
    func fetchTodayExerciseTime(completion: @escaping(Result<Double, Error>) -> Void) {
        let exercise = HKQuantityType(.appleExerciseTime)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        let query = HKStatisticsQuery(quantityType: exercise, quantitySamplePredicate: predicate) { _, results, error in
                if let error = error {
                    print("❌ HealthKit Query Error: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let quantity = results?.sumQuantity() else {
                    print("⚠️ No exercise data found for today.")
                    completion(.failure(NSError(domain: "HealthKitError", code: -2, userInfo: [NSLocalizedDescriptionKey: "No exercise data recorded."])))
                    return
                }
                
                let exerciseTime = quantity.doubleValue(for: .minute())
                print("✅ Exercise minutes today: \(exerciseTime)")
                
                completion(.success(exerciseTime))
            }
        
        healthStore.execute(query)
    }

    
    
    /// Fetches the total stand hours for the current day
    /// - Parameter completion: A closure that returns a `Result` containing either the total stand hours (Double) or an `Error`
    /// - Note: This function queries the `HKCategoryType(.appleStandHour)` data type.
    func fetchTodayStandHours(completion: @escaping(Result<Int, Error>) -> Void) {
        let stand = HKCategoryType(.appleStandHour)
        
        // Create a predicate to filter stand hours for today
        let predicate = HKQuery.predicateForSamples(withStart: .startOfDay, end: Date())
        
        // Create a sample query to fetch stand hour data
        let query = HKSampleQuery(sampleType: stand, predicate: predicate, limit: HKObjectQueryNoLimit,
            sortDescriptors: nil) { _, results, error in
            
            // Ensure results are valid and there's no error
            guard let samples = results as? [HKCategorySample], error == nil else {
                completion(.failure(error!))
                return
            }
            
            print(samples)
            print(samples.map({ $0.value }))
            let standCount = samples.filter({ $0.value == 0 }).count
            // Placeholder success result (actual calculation should be implemented)
            completion(.success(standCount))
        }
        
        healthStore.execute(query)
    }
    
    // MARK: Fitness Activity
    /// Fetches today's step count
    func fetchTodaySteps(completion: @escaping (Result<Activity, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        
        // Ensure the start and end times cover the full day
        let startOfDay = Calendar.current.startOfDay(for: Date())
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay)
        
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            if let error = error {
                print("❌ HealthKit Query Error: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            guard let quantity = results?.sumQuantity() else {
                print("⚠️ No step data found for today.")
                let defaultActivity = Activity(
                    title: "Today Steps",
                    subtitle: "Goal: 800",
                    image: "figure.walk",
                    tintColor: .gray, // Indicate no data with gray color
                    amount: "0" // Default to zero if no data is available
                )
                completion(.success(defaultActivity))
                return
            }
            
            let stepsCount = quantity.doubleValue(for: .count())
            print("✅ Steps counted today: \(stepsCount)")
            
            let activity = Activity(
                title: "Today Steps",
                subtitle: "Goal: 800",
                image: "figure.walk",
                tintColor: .green,
                amount: stepsCount.formattedNumberString()
            )
            
            completion(.success(activity))
        }
        
        healthStore.execute(query)
    }

    /// Fetches the user's workout statistics for the current week
    func fetchCurrentWeekWorkoutStats(completion: @escaping(Result<[Activity], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var runningCount: Int = 0
            var strengthCount: Int = 0
            var soccerCount: Int = 0
            var basketballCount: Int = 0
            var stairsCount: Int = 0
            var kickboxingCount: Int = 0
            
            for workout in workouts {
                let duration = Int(workout.duration)/60
                if workout.workoutActivityType == .running {
                    runningCount += duration
                } else if workout.workoutActivityType == .traditionalStrengthTraining {
                    strengthCount += duration
                } else if workout.workoutActivityType == .soccer {
                    soccerCount += duration
                } else if workout.workoutActivityType == .basketball {
                    basketballCount += duration
                } else if workout.workoutActivityType == .stairClimbing {
                    stairsCount += duration
                } else if workout.workoutActivityType == .kickboxing {
                    kickboxingCount += duration
                }
            }
            
            completion(.success(generateActivitiesFromDurations(running: runningCount, strength: strengthCount, soccer: soccerCount, basketball: basketballCount, stairs: stairsCount, kickboxing: kickboxingCount)))
        }
        
        healthStore.execute(query)
    }
    
    
    func generateActivitiesFromDurations(running: Int, strength: Int, soccer: Int, basketball: Int, stairs: Int, kickboxing: Int)-> [Activity] {
        return [
            Activity(title: "Running", subtitle: "This week", image: "figure.run", tintColor: .green, amount: "\(running) mins"),
            Activity(title: "Strength Training", subtitle: "This week", image: "dumbbell", tintColor: .green, amount: "\(strength) mins"),
            Activity(title: "Soccer", subtitle: "This week", image: "figure.soccer", tintColor: .green, amount: "\(soccer) mins"),
            Activity(title: "Basketball", subtitle: "This week", image: "figure.basketball", tintColor: .green, amount: "\(basketball) mins"),
            Activity(title: "Stairstepper", subtitle: "This week", image: "figure.stairs", tintColor: .green, amount: "\(running) mins"),
            Activity(title: "Kickboxing", subtitle: "This week", image: "figure.kickboxing", tintColor: .green, amount: "\(running) mins"),

        ]
    }
    
    // MARK: Recent Workouts
    /// Fetches workouts for a given month
    /// - Paramters:
    /// - month: The date representing the month to fetch workouts for
    /// - completion: A completion handler retunring 'Result' with an array of 'Workout' or an error
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        
        let (startDate, endDate) = month.fetchMonthStartAndEndDate()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(error!))
                return
            }
                        
            let workoutsArray = workouts.map( { Workout(id: nil, title: $0.workoutActivityType.name, image: $0.workoutActivityType.image, tintColor: $0.workoutActivityType.color, duration: "\(Int($0.duration)/60) mins", date: $0.startDate.formatWorkoutDate(), calories: ($0.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumberString() ?? "-") + "kcal") })
            completion(.success(workoutsArray))
        }
        healthStore.execute(query)
    }
}

// MARK: CHARTSVIEW DATA
extension HealthManager {
    
    func fetchDailySteps(startDate: Date, completion: @escaping (Result<[DailyStepModel], Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let interval = DateComponents(day: 1)
        
        let query = HKStatisticsCollectionQuery(
            quantityType: steps,
            quantitySamplePredicate: nil,
            anchorDate: startDate,
            intervalComponents: interval
        )
        
        query.initialResultsHandler = { _, results, error in
            guard let result = results, error == nil else {
                completion(.failure(error!))
                return
            }
            
            var dailysteps: [DailyStepModel] = []
            
            result.enumerateStatistics(from: startDate, to: Date()) { statistics, stop in
                dailysteps.append(DailyStepModel(date: statistics.startDate, count: Int(statistics.sumQuantity()?.doubleValue(for: .count()) ?? 0)))
            }
            completion(.success(dailysteps))
        }
        healthStore.execute(query)
        
    }
    
    /// Structure to hold year-to-date and one-year step data.
    struct YearChartDataResult {
        let ytd: [MonthlyStepModel] // Steps data for the current year-to-date
        let oneYear: [MonthlyStepModel] // Steps data for the last 12 months
    }
    
    /// Fetches step count data for the past 12 months and year-to-date
    /// - Paramter completion: A completion handler returning a 'Resut'
    func fetchYTDAndOneYearChartData(completion: @escaping (Result<YearChartDataResult, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let calendar = Calendar.current
        
        var oneYearmonths = [MonthlyStepModel]()
        var ytdMonths = [MonthlyStepModel]()
        
        for i in 0...11 {
            let month = calendar.date(byAdding: .month, value: -i, to: Date()) ?? Date()
            let (startOfMonth, endOfMonth) = month.fetchMonthStartAndEndDate()
            let predicate = HKQuery.predicateForSamples(withStart: startOfMonth, end: endOfMonth)
            let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results,
                error in
                if let error = error, error.localizedDescription != "No data available for the specified predicate." {
                    completion(.failure(error))
                }
                
                let steps = results?.sumQuantity()?.doubleValue(for: .count()) ?? 0
                
                if i == 0 {
                    oneYearmonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                } else {
                    oneYearmonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    if calendar.component(.year, from: Date()) == calendar.component(.year, from: month) {
                        ytdMonths.append(MonthlyStepModel(date: month, count: Int(steps)))
                    }
                }
                
                if i == 11 {
                    completion(.success(YearChartDataResult(ytd: ytdMonths, oneYear: oneYearmonths)))
                }
            }
            healthStore.execute(query)
        }
    }
}

// MARK: LEADERBOARD VIEW
extension HealthManager {
    
    func fetchCurrentWeekStepCount(completion: @escaping (Result<Double, Error>) -> Void) {
        let steps = HKQuantityType(.stepCount)
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKStatisticsQuery(quantityType: steps, quantitySamplePredicate: predicate) { _, results, error in
            guard let quantity = results?.sumQuantity(), error == nil else {
                completion(.failure(error!))
                return
            }
            
            let steps = quantity.doubleValue(for: .count())
            completion(.success(steps))
        }
        healthStore.execute(query)
    }
}
