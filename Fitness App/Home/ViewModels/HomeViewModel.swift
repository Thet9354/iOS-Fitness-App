//
//  HomeViewModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 16/3/25.
//

import Foundation

class HomeViewModel: ObservableObject {
        
    let healthManager = HealthManager.shared ///Singleton instance of 'HealthManager' to interact with HealthKit data
    
    // MARK: VARIABLE
    /// Published let's the class know that changes to this variable needs to be published and view will be updated
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand: Int  = 0
    
    @Published var activities = [Activity]() /// List of fitness activities
    
    /// Sample list of recent workouts (for UI preview/testing purpose)
    @Published var workouts = [Workout]()
    
    @Published var presentError = false
    
    
    /// Mock activity data for testing UI
    var mockActivities = [
        Activity(title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .green, amount: "9812"),
        Activity(title: "Today steps", subtitle: "Goal 1,000", image: "figure.walk", tintColor: .red, amount: "812"),
        Activity(title: "Today steps", subtitle: "Goal 13,000", image: "figure.walk", tintColor: .blue, amount: "9,815"),
        Activity(title: "Today steps", subtitle: "Goal 50,000", image: "figure.walk", tintColor: .purple, amount: "104,812"),
    ]
    
    /// Mock workout data for testing UI.
    var mockWorkouts = [
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 1, title: "Strength Training", image: "figure.run", tintColor: .red, duration: "52 mins", date: "Aug 2", calories: "600 kcal"),
        Workout(id: 2, title: "Running", image: "figure.run", tintColor: .purple, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 3, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
    ]
    
    /// Initializes the ViewModel and requests HealthKit access
    /// Calls multiple fetch functions to retrieve health data.
    // MARK: INITIALISATION
    init() {
        Task {
            do {
                try await healthManager.requestHealthKitAccess()
                
                async let fetchCalories: () = try await fetchTodayCalories()
                async let fetchExercise: () = try await fetchTodayExerciseTime()
                async let fetchStand: () = try await fetchTodayStandHours()
                async let fetchSteps: () = try await fetchTodaysSteps()
                async let fetchActivities: () = try await fetchCurrentWeekActivities()
                async let fetchWorkouts: () = try await fetchRecentWorkouts()
                
                let (_, _, _, _, _, _) = (try await fetchCalories, try await fetchExercise, try await fetchStand, try await fetchSteps, try await fetchActivities, try await fetchWorkouts)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.presentError = true
                }
            }
        }
        
    }
    
    // MARK: FETCHTODAYCALORIES() FUNCTION
    /// Fetch today's calories burn from HealthKit and updates the 'activities' array.
    /// Uses 'fetchTodayCaloriesBurned' from 'HealthManager' to retrieve the values
    /// Converts the returned value into an integer and updates the 'calories' property
    /// Creates an 'Activity' object with the calories value ad appends it to activities
    func fetchTodayCalories() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchTodayCaloriesBurned { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let calories):
                    DispatchQueue.main.async {
                        self.calories = Int(calories)
                        let activity = Activity(title: "Calories Burnt", subtitle: "Today",
                                                image: "flame", tintColor: .red, amount: calories.formattedNumberString())
                        self.activities.append(activity)
                        continuation.resume()
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        let activity = Activity(title: "Calories Burnt", subtitle: "Today",
                                                image: "flame", tintColor: .red, amount: "---")
                        self.activities.append(activity)
                        continuation.resume(throwing: failure)
                    }
                }
            }
        }) as Void
    }
    
    // MARK: FETCHTODAYEXERCISETIME() FUNCTION
    /// Fetches today's total exercise time in minutes from HealthKit.
    /// Uses `fetchTodayExerciseTime` from `HealthManager`.
    /// Updates the `exercise` property to trigger UI updates.
    func fetchTodayExerciseTime() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchTodayExerciseTime { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let exercise):
                    DispatchQueue.main.async {
                        self.exercise = Int(exercise)
                        continuation.resume()
                    }
                case .failure(let failure):
                    print("Yeap it doesnt show")
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    // MARK: FETCHTODAYSTANDHOURS() FUNCTION
    /// Fetches the number of stand hours recorded for today from HealthKit.
    /// Uses `fetchTodayStandHours` from `HealthManager`.
    /// Updates the `stand` property to reflect the latest stand hour count.
    func fetchTodayStandHours() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchTodayStandHours { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let hours):
                    DispatchQueue.main.async {
                        self.stand = hours
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    // MARK: Fitness Activity DATA
    /// Fetches the total steps taken today from HealthKit and appends it to `activities`.
    /// - Uses `fetchTodaySteps` from `HealthManager` to get step count.
    /// - Adds the retrieved data as an `Activity` object in the `activities` list.
    func fetchTodaysSteps() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchTodaySteps { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let activity):
                    DispatchQueue.main.async {
                        self.activities.append(activity)
                        continuation.resume()
                    }
                case .failure(let failure):
                    DispatchQueue.main.async {
                        self.activities.append(Activity(title: "Today Steps", subtitle: "Goal: 800", image: "figure.walk", tintColor: .green, amount: "---"))
                        continuation.resume(throwing: failure)
                    }
                }
            }
        }) as Void
    }
    
    // MARK: FETCHCURRENTWEEKACTIVITIES() FUNCTION
    /// Fetches workout statistic for the current week from HealthKit
    /// - Uses `fetchCurrentWeekWorkoutStats` from `HealthManager`.
    /// - Updates the `activities` array to include the weekly activity stats.
    func fetchCurrentWeekActivities() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchCurrentWeekWorkoutStats { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let activities):
                    DispatchQueue.main.async {
                        self.activities.append(contentsOf: activities)
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
    
    // MARK: Recent Workouts FUNCTION
    /// Fetches recent workouts from HealthKit for the current month
    /// - Uses 'fetchWorkoutsForMonth' from 'HealthManager'
    /// - Limits the number of workouts displayed to the 4 most recent entries
    func fetchRecentWorkouts() async throws {
        try await withCheckedThrowingContinuation({ continuation in
            healthManager.fetchWorkoutsForMonth(month: Date()) { result in
                switch result {
                case . success(let workouts):
                    DispatchQueue.main.async {
                        self.workouts = Array(workouts.prefix(4))
                        continuation.resume()
                    }
                case .failure(let failure):
                    continuation.resume(throwing: failure)
                }
            }
        }) as Void
    }
}
