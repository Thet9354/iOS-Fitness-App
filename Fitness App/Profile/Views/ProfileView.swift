//
//  ProfileView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 3/4/25.
//

import SwiftUI

struct ProfileView: View {
    
    //MARK: VARIABLE
    @AppStorage("profileName") var profileName: String?
    @AppStorage("profileImage") var profileImage: String?
    
    @State private var isEdittingName = true
    @State private var currentName: String = ""
    @State private var isEdittingImage = false
    @State private var selectedImage: String?
    
    @State var images = ["avatar 1", "avatar 2", "avatar 3", "avatar 4", "avatar 5", "avatar 6", "avatar 7", "avatar 8", "avatar 9", "avatars 10"]
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                Image(profileImage ?? "avatar 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding(.all, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.gray.opacity(0.25))
                    )
                    .onTapGesture {
                        withAnimation {
                            isEdittingName = false
                            isEdittingImage.toggle()
                        }
                    }
                
                
                VStack(alignment: .leading) {
                    Text("Good morning,")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .minimumScaleFactor(0.5)
                    
                    Text(profileName ?? "Name")
                        .font(.title)
                }
            }
            
            if isEdittingName {
                TextField("Name ...", text: $currentName)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke()
                    )
                
                HStack {
                    FitnessProfileEditButtonView(title: "Cancel", backgroundColor: .gray.opacity(0.1)) {
                        withAnimation {
                            isEdittingName = false
                        }
                    }
                    .foregroundColor(.red)
                    
                    FitnessProfileEditButtonView(title: "Done", backgroundColor: .primary) {
                        if !currentName.isEmpty {
                            withAnimation {
                                profileName = currentName
                                isEdittingName = false
                            }
                        }
                    }
                    .foregroundColor(Color(uiColor: .systemBackground))
                }

            }
            
            
            if isEdittingImage {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(images, id: \.self) { image in
                            Button {
                                withAnimation {
                                    selectedImage = image
                                }
                            } label: {
                                VStack {
                                    Image(image)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 100, height: 100)
                                    
                                    if selectedImage == image {
                                        Circle()
                                            .frame(width: 16, height: 16)
                                            .foregroundColor(.primary)
                                    }
                                }
                                .padding()
                            }
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.gray.opacity(0.15))
                )
                
                FitnessProfileEditButtonView(title: "Done", backgroundColor: .primary) {
                    withAnimation {
                        profileImage = selectedImage
                        isEdittingImage = false
                    }
                }
                .foregroundColor(Color(uiColor: .systemBackground))
                .padding(.bottom)

            }
            
             
            VStack {
                FitnessProfileItemButton(title: "Edit Name", image: "square.and.pencil") {
                    withAnimation {
                        isEdittingName = true
                        isEdittingImage = false
                    }
                }
                
                FitnessProfileItemButton(title: "Edit Image", image: "square.and.pencil") {
                    withAnimation {
                        isEdittingName = false
                        isEdittingImage = true
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.gray.opacity(0.15))
            )
            
            VStack {
                FitnessProfileItemButton(title: "Contact Us", image: "envelope") {
                    print("contact")
                }
                
                FitnessProfileItemButton(title: "Privacy policy", image: "doc") {
                    print("privacy")
                }
                
                FitnessProfileItemButton(title: "Terms of Service", image: "doc") {
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
        .onAppear {
            selectedImage = profileImage
        }
    }
}

#Preview {
    ProfileView()
}
