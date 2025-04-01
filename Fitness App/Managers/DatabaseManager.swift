//
//  DatabaseManager.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 27/3/25.
//

import Foundation
import FirebaseFirestore

/// Singleton class responsible for handling Firebase Firestore interactions.
/// Provides method for fetching and updating leaderboard data
class DatabaseManager {
    
    /// Shared singleton instance of 'DatabaseManager'
    static let shared = DatabaseManager()
    
    /// Private initializer to prevent multiple instances of 'DatabaseManager' from being created.
    private init() {}
    
    /// Reference to the Firestore database instance.
    private let database = Firestore.firestore()
    
    /// The name of the Firestore collection for the current week's leaderboard
    /// It is dynamically generated based on the Monday of the current week
    let weeklyLeaderboard = "\(Date().mondayDateFormat())-leaderboard"
    
    // MARK: FETCH LEADERBOARD
    /// Fetches the leaderboard data for the current week from Firestore
    /// Returns: An array of 'LeaderboardUser' objects representing users and thier step counts
    /// Throws: An error if the Firestore fetch operation fails.
    func fetchLeaderboards() async throws -> [LeaderboardUser] {
        
        // Attempt to fetch all documents in the leaderboard collection for the current weeks
        let snapshot = try await database.collection(weeklyLeaderboard).getDocuments()
        
        // Map each document to a 'LeaderboardUser' model, ignoring invalid documents.
        return try snapshot.documents.compactMap({ try $0.data(as: LeaderboardUser.self) })
    }
    
    // MARK: POST (UPDATE) LEADERBOARD FOR CURRENT USER
    
    /// Updates or adds the step count data for a specific user in the current week's leaderboard
    /// - Parameter leader: A 'LeaderboardUser' object containing the user's step count and details.
    /// - Throws: An error if the Firestore write operation fails.
    func postStepCountUpdateForUser(leader: LeaderboardUser) async throws {
        
        // Encode the 'Leaderboarduser' model into Firestore-compatible data
        let data = try Firestore.Encoder().encode(leader)
        
        // Update the leaderboard entry for the user.
        // Uses 'setData' with 'merge: false' to completely replace existing data
        try await database.collection(weeklyLeaderboard).document(leader.username).setData(data, merge: false)
    }
    
}
