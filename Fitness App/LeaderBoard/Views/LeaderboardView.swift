//
//  LeaderboardView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 26/3/25.
//

import SwiftUI

/// 'LeaderboardView' displays the top 10 users based on step count, along with the current user's ranking if applicable
struct LeaderboardView: View {
    
    // MARK: VARIABLE
    
    @AppStorage("username") var username: String? /// Stroes the logged-in username using '@AppStorage' to persust user settings
    @StateObject var viewModel = LeaderboardViewModel() /// The view model responsible for managing leaderboard data
    @Binding var showTerms: Bool ///Controls whether the terms and conditions view is displayed
    
    // MARK: BODY
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .trailing) {
                    Text("Leaderboard")
                        .font(.largeTitle)
                        .bold()
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        viewModel.setUpLeaderboardData()
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .resizable()
                            .scaledToFit()
                            .bold()
                            .foregroundColor(Color(uiColor: .label))
                            .frame(width: 28, height: 28)
                            .padding(.trailing)
                    }

                }
                
                HStack {
                    Text("Name")
                        .bold()
                    
                    Spacer()
                    
                    Text("Steps")
                        .bold()
                }
                .padding()
                
                // Display top 10 users using a LazyVStack for efficency
                LazyVStack(spacing: 24) {
                    ForEach(Array(viewModel.leaderResult.top10.enumerated()), id: \.element.id) { (idx, person) in
                        HStack {
                            Text("\(idx + 1).")
                            
                            Text(person.username)
                            
                            // Highlight the logged-in user's entry with a crown icon
                            if username == person.username {
                                Image(systemName: "crown.fill")
                                    .foregroundColor(.yellow)
                            }
                            
                            Spacer()
                            
                            Text("\(person.count)")
                        }
                        .padding(.horizontal)
                    }
                }
                
                // If the current user is not in the top 10, show their ranking separately
                if let user = viewModel.leaderResult.user {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(.gray.opacity(0.5))
                    
                    HStack {
                        Text(user.username)
                        
                        Spacer()
                        
                        Text("\(user.count)")
                    }
                    .padding(.horizontal)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            if showTerms {
                TermsView(showTerms: $showTerms)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .alert("Oops", isPresented: $viewModel.showAlert) {
            Button("Ok", role: .cancel) { }
        } message: {
            Text("There was an issue fetching some of your data. Some health tracking requires an Apple Watch.")
        }
        .onChange(of: showTerms) { oldValue, newValue in
            if !newValue && username != nil {
                viewModel.setUpLeaderboardData()
            }
        }
    }
}

#Preview {
    LeaderboardView(showTerms: .constant(false))
}
