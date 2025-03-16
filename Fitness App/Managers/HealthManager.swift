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
        
        let healthType: Set = [calories, exercise, stand]
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
}
