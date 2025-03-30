//
//  LeaderboardUser.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 30/3/25.
//

import Foundation

struct LeaderboardUser: Codable, Identifiable {
    let id = UUID()
    let username: String
    let count: Int
}
