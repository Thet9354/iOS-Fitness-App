//
//  FitnessTabView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 15/3/25.
//

import SwiftUI

struct FitnessTabView: View {
    
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
                .tag("Home") // For tag, normally uased as int or string, string preferable
                .tabItem {
                    Image(systemName: "house") // system name for SF symbols
                    
                    Text("Home")
                }
            
            HistoricDataView()
                .tag("Historic")
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    
                    Text("Charts")
                }
        }
    }
}

#Preview {
    FitnessTabView()
}
