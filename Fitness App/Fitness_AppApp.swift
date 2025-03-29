//
//  Fitness_AppApp.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 15/3/25.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Fitness_AppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    /// MVVM model
    /// Model(Data and Logic): The Model represents the data and encapsulates the core business logic of the application. It manages the data and provides methods for data manipulation,
    /// View(User Interface): The View represents the user interface components and their layout. It is responsible for displaying the data to the user and capturing user interactions.
    /// ViewModel(The Bridge): The Viewmodel acts as an intermediary between the Model and the View. It contains presentation logic, transforming the raw data from the Model into a format that the View can easily display. It also handles user input from the View and updates the Model Accordingly
    var body: some Scene {
        WindowGroup {
            FitnessTabView()
        }
    }
}
