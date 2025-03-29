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
    
    let database = Firestore.firestore()
    let weeklyLeaderboard = "\(Date().mondayDateFormat())-leaderboard"
    
    // MARK: FETCH LEADERBOARD
    func fetchLeaderboard() async throws {
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        
        print(snapshot.documents)
        print(snapshot.documents.first?.data())
    }
    
    // MARK: POST (UPDATE) LEADERBOARD FOR CURRENT USER
    func postStepCountUpdateFor(username: String, count: Int) async throws {
        let leader = LeaderboardUser(username: username, count: count)
        let data = try Firestore.Encoder().encode(leader)
        try await database.collection(weeklyLeaderboard).document(username).setData(data, merge: false)
    }
    
}
