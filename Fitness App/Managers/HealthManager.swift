//
//  HealthManager.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 16/3/25.
//

import Foundation
import HealthKit

/// Extension to add a computed property for getting the start of the current day
extension Date {
    
    static var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date()) // return the start of the current day
    }
    
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2
        return calendar.date(from: components) ?? Date()
    }
    
    /// Returns the start and end dates of the month for the given date.
    /// - Returns: A tuple containing the first day and the last day of the month.
    func fetchMonthStartAndEndDates() -> (Date, Date) {
        let calendar = Calendar.current
        
        // Extract the year and month components from the current date
        let startDateComponent = calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))
        
        // Construct the first day of the month using the extracted components
        let startDate = calendar.date(from: startDateComponent) ?? self
        
        // Compute the last day of the month by adding 1 month and subtracting 1 day from the start date
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? self
        
        return (startDate, endDate)
    }
    
    func formatWorkoutDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM d"
        return formatter.string(from: self)
    }
}

extension Double {
    
    func formattedNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}

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
                print(error.localizedDescription)
            }
        }
    }
    
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
                completion(.failure(NSError()))
                return
            }
            
            // Convert HealthKit quantity to kilocalories (kcal)
            let caloriesCount = quantity.doubleValue(for: .kilocalorie())
            completion(.success(caloriesCount))
        }
        
        // Execute the HealthKit query
        healthStore.execute(query)
    }
    
    
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
                completion(.failure(NSError()))
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

    
    func fetchCurrentWeekWorkoutStats(completion: @escaping(Result<[Activity], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        let predicate = HKQuery.predicateForSamples(withStart: .startOfWeek, end: Date())
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { [weak self] _, results, error in
            guard let workouts = results as? [HKWorkout], let self = self, error == nil else {
                completion(.failure(URLError(.badURL)))
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
    func fetchWorkoutsForMonth(month: Date, completion: @escaping (Result<[Workout], Error>) -> Void) {
        let workouts = HKSampleType.workoutType()
        
        let (startDate, endDate) = month.fetchMonthStartAndEndDates()
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: workouts, predicate: predicate, limit: HKObjectQueryNoLimit,
                                  sortDescriptors: [sortDescriptor]) { _, results, error in
            guard let workouts = results as? [HKWorkout], error == nil else {
                completion(.failure(URLError(.badURL)))
                return
            }
                        
            let workoutsArray = workouts.map( { Workout(id: nil, title: $0.workoutActivityType.name, image: $0.workoutActivityType.image, tintColor: $0.workoutActivityType.color, duration: "\(Int($0.duration)/60) mins", date: $0.startDate.formatWorkoutDate(), calories: ($0.totalEnergyBurned?.doubleValue(for: .kilocalorie()).formattedNumberString() ?? "-") + "kcal") })
            completion(.success(workoutsArray))
        }
        healthStore.execute(query)
    }
    
    
}
