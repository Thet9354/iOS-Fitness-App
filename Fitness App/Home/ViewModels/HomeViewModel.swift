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
    @Published var workouts = [
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 1, title: "Strength Training", image: "figure.run", tintColor: .red, duration: "52 mins", date: "Aug 2", calories: "600 kcal"),
        Workout(id: 2, title: "Running", image: "figure.run", tintColor: .purple, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 3, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
    ]
    
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
                
                fetchTodayCalories()
                fetchTodayExerciseTime()
                fetchTodayStandHours()
                fetchTodaysSteps()
                fetchCurrentWeekActivities()
                fetchRecentWorkouts()
            } catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    // MARK: FETCHTODAYCALORIES() FUNCTION
    /// Fetch today's calories burn from HealthKit and updates the 'activities' array.
    /// Uses 'fetchTodayCaloriesBurned' from 'HealthManager' to retrieve the values
    /// Converts the returned value into an integer and updates the 'calories' property
    /// Creates an 'Activity' object with the calories value ad appends it to activities
    func fetchTodayCalories() {
        healthManager.fetchTodayCaloriesBurned { result in
            switch result {
            case .success(let calories):
                DispatchQueue.main.async {
                    self.calories = Int(calories)
                    let activity = Activity(title: "Calories Burnt", subtitle: "Today",
                                            image: "flame", tintColor: .red, amount: calories.formattedNumberString())
                    self.activities.append(activity)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    
    // MARK: FETCHTODAYEXERCISETIME() FUNCTION
    /// Fetches today's total exercise time in minutes from HealthKit.
    /// Uses `fetchTodayExerciseTime` from `HealthManager`.
    /// Updates the `exercise` property to trigger UI updates.
    func fetchTodayExerciseTime() {
        healthManager.fetchTodayExerciseTime { result in
            switch result {
            case .success(let exercise):
                DispatchQueue.main.async {
                    self.exercise = Int(exercise)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    
    // MARK: FETCHTODAYSTANDHOURS() FUNCTION
    /// Fetches the number of stand hours recorded for today from HealthKit.
    /// Uses `fetchTodayStandHours` from `HealthManager`.
    /// Updates the `stand` property to reflect the latest stand hour count.
    func fetchTodayStandHours() {
        healthManager.fetchTodayStandHours { result in
            switch result {
            case .success(let hours):
                DispatchQueue.main.async {
                    self.stand = hours
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    // MARK: Fitness Activity DATA
    /// Fetches the total steps taken today from HealthKit and appends it to `activities`.
    /// - Uses `fetchTodaySteps` from `HealthManager` to get step count.
    /// - Adds the retrieved data as an `Activity` object in the `activities` list.
    func fetchTodaysSteps() {
        healthManager.fetchTodaySteps { result in
            switch result {
            case .success(let activity):
                DispatchQueue.main.async {
                    self.activities.append(activity)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    
    // MARK: FETCHCURRENTWEEKACTIVITIES() FUNCTION
    /// Fetches workout statistic for the current week from HealthKit
    /// - Uses `fetchCurrentWeekWorkoutStats` from `HealthManager`.
    /// - Updates the `activities` array to include the weekly activity stats.
    func fetchCurrentWeekActivities() {
        healthManager.fetchCurrentWeekWorkoutStats { result in
            switch result {
            case .success(let activities):
                DispatchQueue.main.async {
                    self.activities.append(contentsOf: activities)
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    // MARK: Recent Workouts FUNCTION
    /// Fetches recent workouts from HealthKit for the current month
    /// - Uses 'fetchWorkoutsForMonth' from 'HealthManager'
    /// - Limits the number of workouts displayed to the 4 most recent entries
    func fetchRecentWorkouts() {
        healthManager.fetchWorkoutsForMonth(month: Date()) { result in
            switch result {
            case . success(let workouts):
                DispatchQueue.main.async {
                    self.workouts = Array(workouts.prefix(4))
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
