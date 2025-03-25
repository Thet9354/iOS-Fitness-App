//
//  MonthlyStepModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 25/3/25.
//

import Foundation

struct MonthlyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
