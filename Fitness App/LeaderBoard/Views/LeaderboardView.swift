//
//  LeaderboardView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 26/3/25.
//

import SwiftUI

struct LeaderboardUser: Codable, Identifiable {
    let id = UUID()
    let username: String
    let count: Int
}

class LeaderboardViewModel: ObservableObject {
    
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
}

struct LeaderboardView: View {
    
    // MARK: VARIABLE
    @StateObject var viewModel = LeaderboardViewModel()
    
    @Binding var showTerms: Bool
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
            
            HStack {
                Text("Name")
                    .bold()
                
                Spacer()
                
                Text("Steps")
                    .bold()
            }
            .padding()
            
            LazyVStack(spacing: 24) {
                ForEach(viewModel.mockData) { person in
                    HStack {
                        Text("1.")
                        
                        Text(person.username)
                        
                        Spacer()
                        
                        Text("\(person.count)")
                    }
                    .padding(.horizontal)
                }
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .fullScreenCover(isPresented: $showTerms) {
            TermsView()
        }
        .task {
            do {
                try await DatabaseManager.shared.postStepCountUpdateFor(username: "jason", count: 5464)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
