//
//  LeaderboardViewModel.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 30/3/25.
//

import Foundation

class LeaderboardViewModel: ObservableObject {
    
    // MARK: VARIABLES
    @Published var leaders = [LeaderboardUser]()
    
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
    
    init () {
        Task {
            do {
                try await postStepCountUpdateForUser(username: "xcode", count: 123)
                let result = try await fetchLeaderboards()
                DispatchQueue.main.async {
                    self.leaders = result.top10
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    struct LeaderboardResult {
        let user: LeaderboardUser?
        let top10: [LeaderboardUser]
    }
    
    func fetchLeaderboards() async throws -> LeaderboardResult {
        let leaders = try await DatabaseManager.shared.fetchLeaderboards()
        let top10 = Array(leaders.sorted(by: { $0.count > $1.count }).prefix(10))
        let username = UserDefaults.standard.string(forKey: "username")
        
        if let username = username {
            let user = leaders.first(where: { $0.username == username })
            return LeaderboardResult(user: user, top10: top10)
        } else {
            return LeaderboardResult(user: nil, top10: top10)
        }
    }
    
    func postStepCountUpdateForUser(username: String, count: Int) async throws {
        try await DatabaseManager.shared.postStepCountUpdateForUser(leader: LeaderboardUser(username: username, count: count))
    }
}
