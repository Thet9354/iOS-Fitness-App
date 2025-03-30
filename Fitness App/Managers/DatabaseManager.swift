//
//  DatabaseManager.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 27/3/25.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    private let database = Firestore.firestore()
    let weeklyLeaderboard = "\(Date().mondayDateFormat())-leaderboard"
    
    // MARK: FETCH LEADERBOARD
    func fetchLeaderboards() async throws -> [LeaderboardUser] {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        return try snapshot.documents.compactMap({ try $0.data(as: LeaderboardUser.self) })
    }
    
    // MARK: POST (UPDATE) LEADERBOARD FOR CURRENT USER
    func postStepCountUpdateForUser(leader: LeaderboardUser) async throws {
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(leader.username).setData(data, merge: false)
    }
    
}
