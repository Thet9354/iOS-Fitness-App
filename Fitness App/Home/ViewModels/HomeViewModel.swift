//
//  HomeViewModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 16/3/25.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    // Published let's the class know that changes to this variable needs to be published and view will be updated
    
    var calories: Int = 123
    var active: Int = 52
    var stand: Int = 8
    
    var mockActivities = [
        Activity(id: 0, title: "Today steps", subtitle: "Goal 12,000", image: "figure.walk", tintColor: .green, amount: "9812"),
        Activity(id: 1, title: "Today steps", subtitle: "Goal 1,000", image: "figure.walk", tintColor: .red, amount: "812"),
        Activity(id: 2, title: "Today steps", subtitle: "Goal 13,000", image: "figure.walk", tintColor: .blue, amount: "9,815"),
        Activity(id: 3, title: "Today steps", subtitle: "Goal 50,000", image: "figure.walk", tintColor: .purple, amount: "104,812"),
    ]
    
    var mockWorkouts = [
        Workout(id: 0, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 1, title: "Strength Training", image: "figure.run", tintColor: .red, duration: "52 mins", date: "Aug 2", calories: "600 kcal"),
        Workout(id: 2, title: "Running", image: "figure.run", tintColor: .purple, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
        Workout(id: 3, title: "Running", image: "figure.run", tintColor: .cyan, duration: "51 mins", date: "Aug 1", calories: "512 kcal"),
    ]
}
