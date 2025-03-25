//
//  DailyStepModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 25/3/25.
//

import Foundation

struct DailyStepModel: Identifiable {
    let id = UUID()
    let date: Date
    let count: Int
}
