//
//  HomeView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 15/3/25.
//

import SwiftUI

struct HomeView: View {
    
    // Variable
    @StateObject var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .padding()
                    
                    HStack {
                        
                        Spacer() // Whatever comes below this spacer will all be pushed to the right side of the screen
                        
                        VStack(alignment: .leading) {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Calories")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                
                                Text("\(viewModel.calories)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Active")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.green)
                                
                                Text("\(viewModel.exercise)")
                                    .bold()
                            }
                            .padding(.bottom)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Stand")
                                    .font(.callout)
                                    .bold()
                                    .foregroundColor(.red)
                                
                                Text("\(viewModel.stand)")
                                    .bold()
                            }
                        }
                        
                        Spacer()
                        
                        ZStack {
                            ProgressCircleView(progress: $viewModel.calories, goal: 600, color: .red)
                            
                            ProgressCircleView(progress: $viewModel.exercise, goal: 60, color: .green)
                                .padding(.all, 20)
                            
                            ProgressCircleView(progress: $viewModel.stand, goal: 12, color: .red)
                                .padding(.all, 40)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .padding()
                    
                    HStack {
                        Text("Fitness Activity")
                            .font(.title2)
                        
                        Spacer()
                        
                        Button {
                            print("Show more")
                        } label: {
                            Text("Show more")
                                .padding()
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal)
                    
                    if !viewModel.activities.isEmpty {
                        LazyVGrid(columns: Array(repeating: GridItem(spacing: 20), count: 2)) {
                            ForEach(viewModel.activities, id: \.title) { activity in
                                ActivityCardView(activity: activity)
                                
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    HStack {
                        Text("Fitness Activity")
                            .font(.title2)
                        
                        Spacer()
                        
                        NavigationLink {
                            EmptyView()
                        } label: {
                            Text("Show more")
                                .padding()
                                .foregroundColor(.white)
                                .background(.blue)
                                .cornerRadius(20)
                        }
                        
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    LazyVStack {
                        ForEach(viewModel.workouts, id: \.title) { workout in
                            WorkoutCardView(workout: workout)
                        }
                    }
                    .padding(.bottom)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
