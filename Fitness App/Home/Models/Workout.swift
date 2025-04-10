//
//  Workout.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 16/3/25.
//

import SwiftUI

struct Workout: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let image: String
    let tintColor: Color
    let duration: String
    let date: String
    let calories: String
}
