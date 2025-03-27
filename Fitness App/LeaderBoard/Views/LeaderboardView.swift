//
//  LeaderboardView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 26/3/25.
//

import SwiftUI

struct LeaderboardUser: Codable, Identifiable {
    let id: Int
    let createdAt: String
    let username: String
    let count: Int
}

class LeaderboardViewModel: ObservableObject {
    
    var mockData = [
        LeaderboardUser(id: 0, createdAt: "", username: "Frederick", count: 4124),
        LeaderboardUser(id: 1, createdAt: "", username: "Jason", count: 1124),
        LeaderboardUser(id: 2, createdAt: "", username: "You", count: 41204),
        LeaderboardUser(id: 3, createdAt: "", username: "Paul Hudson", count: 4124),
        LeaderboardUser(id: 4, createdAt: "", username: "Logan", count: 11124),
        LeaderboardUser(id: 5, createdAt: "", username: "Seanallen", count: 124),
        LeaderboardUser(id: 6, createdAt: "", username: "Jackson", count: 12344),
        LeaderboardUser(id: 7, createdAt: "", username: "Catalin", count: 13244),
        LeaderboardUser(id: 8, createdAt: "", username: "Paul", count: 14433),
        LeaderboardUser(id: 9, createdAt: "", username: "Eric", count: 12654),
        LeaderboardUser(id: 10, createdAt: "", username: "Nathan", count: 11345),
        LeaderboardUser(id: 11, createdAt: "", username: "Xavier", count: 12856),
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
                        Text("\(person.id)")
                        
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
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
