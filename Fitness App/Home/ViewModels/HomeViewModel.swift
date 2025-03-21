//
//  HomeViewModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 16/3/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    // Published let's the class know that changes to this variable needs to be published and view will be updated
    
    let healthManager = HealthManager.shared
    
    @Published var calories: Int = 0
    @Published var exercise: Int = 0
    @Published var stand: Int  = 0
    
    @Published var activities = [Activity]()
    @Published var workouts = [
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 1, title: "Strength Training", image: "figure.run", tintColor: .red, duration: "52 mins", date: "Aug 2", calories: "600 kcal"),
        Workout(id: 2, title: "Running", image: "figure.run", tintColor: .purple, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 3, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
    ]
    
    var mockActivities = [
        Activity(title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .green, amount: "9812"),
        Activity(title: "Today steps", subtitle: "Goal 1,000", image: "figure.walk", tintColor: .red, amount: "812"),
        Activity(title: "Today steps", subtitle: "Goal 13,000", image: "figure.walk", tintColor: .blue, amount: "9,815"),
        Activity(title: "Today steps", subtitle: "Goal 50,000", image: "figure.walk", tintColor: .purple, amount: "104,812"),
    ]
    
    var mockWorkouts = [
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 1, title: "Strength Training", image: "figure.run", tintColor: .red, duration: "52 mins", date: "Aug 2", calories: "600 kcal"),
        Workout(id: 2, title: "Running", image: "figure.run", tintColor: .purple, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 3, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
    ]
    
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
    
    // MARK: Fitness Activity
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
    
    // MARK: Recent Workouts
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
