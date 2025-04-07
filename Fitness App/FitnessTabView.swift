//
//  FitnessTabView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 15/3/25.
//

import SwiftUI

struct FitnessTabView: View {
    @AppStorage("username") var username: String?

    @State var showTerms = true
    @State var selectedTab = "Home" //State: Changes to the value update the state of UI
    
    init() {
        // Change the color of the tab when it's selected
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.iconColor = .green // Change selected one only to green
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.green]
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tag("Home") // For tag, normally used as int or string, string preferable
                .tabItem {
                    Image(systemName: "house") // system name for SF symbols
                    
                    Text("Home")
                }
            
            ChartsView()
                .tag("Charts")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    
                    Text("Charts")
                }
            
            LeaderboardView(showTerms: $showTerms)
                .tag("Leaderboards")
                .tabItem {
                    Image(systemName: "list.bullet")
                    
                    Text("Leaderboard")
                }
            
            ProfileView()
                .tag("Profile")
                .tabItem {
                    Image(systemName: "person")
                    
                    Text("Profile")
                }
        }
        .onAppear {
            print(username)
            showTerms = username == nil
        }
    }
}

#Preview {
    FitnessTabView()
}
