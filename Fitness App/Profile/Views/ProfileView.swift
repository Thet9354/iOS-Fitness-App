//
//  ProfileView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 3/4/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image("avatar 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                VStack(alignment: .leading) {
                    Text("Good morning")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    
                    Text("Name")
                        .font(.title)
                }
            }
            
            VStack {
                FitnessProfileButtonView(title: "Edit Name", image: "square.and.pencil") {
                    print("name")
                }
                
                FitnessProfileButtonView(title: "Edit Image", image: "square.and.pencil") {
                    print("image")
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
            VStack {
                FitnessProfileButtonView(title: "Contact Us", image: "envelope") {
                    print("contact")
                }
                
                FitnessProfileButtonView(title: "Privacy policy", image: "doc") {
                    print("privacy")
                }
                
                FitnessProfileButtonView(title: "Terms of Service", image: "doc") {
                    print("terms")
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#Preview {
    ProfileView()
}
