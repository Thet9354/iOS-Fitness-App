//
//  LeaderboardViewModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 30/3/25.
//

import Foundation

/// 'LeaderboardViewModel' is an observable class that manages leaderboard data
/// It fetches leaderboard data from Firestore and updates the leaderboard for a specific user.
class LeaderboardViewModel: ObservableObject {
    
    // MARK: VARIABLES
        
    /// Stores the leaderboard result containing the current user (if available) and the top 10 users.
    @Published var leaderResult = LeaderboardResult(user: nil, top10: [])
    @Published var showAlert = false
    
    /// Mock leaderboard data used for testing the UI previews.
    var mockData = [
        LeaderboardUser(username: "Frederick", count: 4124),
        LeaderboardUser(username: "Jason", count: 1124),
        LeaderboardUser(username: "You", count: 41204),
        LeaderboardUser(username: "Paul Hudson", count: 4124),
        LeaderboardUser(username: "Logan", count: 11124),
        LeaderboardUser(username: "Seanallen", count: 124),
        LeaderboardUser(username: "Jackson", count: 12344),
        LeaderboardUser(username: "Catalin", count: 13244),
        LeaderboardUser(username: "Paul", count: 14433),
        LeaderboardUser(username: "Eric", count: 12654),
        LeaderboardUser(username: "Nathan", count: 11345),
        LeaderboardUser(username: "Xavier", count: 12856),
    ]
    
    // MARK: INITIALIZATION
    
    /// Initializes the 'LeaderboardViewModel', automatically updating the leaderboard for a test user
    init () {
        setUpLeaderboardData()
    }
    
    func setUpLeaderboardData() {
        Task {
            do {
                try await postStepCountUpdateForUser()
                let result = try await fetchLeaderboards()
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.leaderResult = result
                }
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.showAlert = true
                }
            }
        }
    }
    
    /// 'LeaderboardResult' is a structure representing the leaderboard's top users and the current user if available.
    struct LeaderboardResult {
        let user: LeaderboardUser? /// The current user on the leaderboard, if they exists
        let top10: [LeaderboardUser] /// The top 10 users based on step count.
    }
    
    // MARK: - FETCH LEADERBOARDS
    
    /// Fetches the leaderboard data from Firestore and determines the top users.
    /// - Returns: A 'leaderboardResult' containing the top 10 users and the current user (if available)
    /// - Throws: An error if fetching from Firestore fails.
    private func fetchLeaderboards() async throws -> LeaderboardResult {
        
        let leaders = try await DatabaseManager.shared.fetchLeaderboards()
        
        // Sort users by steop count in decending order and select the top 10.
        let top10 = Array(leaders.sorted(by: { $0.count > $1.count }).prefix(10))
        
        // Retrieve the currently logged=in username from UserDefaults.
        let username = UserDefaults.standard.string(forKey: "username")
        
        // Check if the user is in the top 10; if not, find and return their details separately
        if let username = username, !top10.contains(where: { $0.username == username }) {
            let user = leaders.first(where: { $0.username == username })
            return LeaderboardResult(user: user, top10: top10)
        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    enum LeaderboardViewModelError: Error {
        case unabaleToFetchUsername
    }
    
    
    // MARK: POST (UPDATE) STEP COUNT FOR USER
    
    /// Updates the leaderboard with the latest step count for a specific user
    /// - Parameters:
    ///  - username: The name of the user whose step count for a specified user
    ///  - count: The number of steps to record for the user
    ///  - Throws: An error if the Firestore write operation fails.
    private func postStepCountUpdateForUser() async throws {
        guard let username = UserDefaults.standard.string(forKey: "username") else {
            throw LeaderboardViewModelError.unabaleToFetchUsername
        }
        let steps = try await fetchCurrentWeekStepCount()
        try await DatabaseManager.shared.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: Int(steps)))
    }
    
    private func fetchCurrentWeekStepCount() async throws -> Double {
        try await withCheckedThrowingContinuation({ continuation in
            HealthManager.shared.fetchCurrentWeekStepCount { result in
                continuation.resume(with: result)
            }
            
        })
    }
}
