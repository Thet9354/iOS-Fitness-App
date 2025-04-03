//
//  TermsView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 26/3/25.
//

import SwiftUI

struct TermsView: View {
    
    // MARK: VARIABLE
    @Binding var showTerms: Bool
    @State var name = ""
    @AppStorage("username") var username: String?
    @State var acceptedTerms = false
    
    var body: some View {
        VStack {
            Text("Leaderboard")
                .font(.largeTitle)
                .bold()
            
            Spacer()
            
            TextField("Username", text: $name)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke()
                )
            
            HStack(alignment: .top) {
                Button {
                    withAnimation {
                        acceptedTerms.toggle()
                    }
                } label: {
                    if acceptedTerms {
                        Image(systemName: "square.inset.filled")
                        
                    } else {
                        Image(systemName: "square")
                    }
                }

                
                Text("By checking you agree to the terms and enter into the leaderboard competiton")
            }
            
            Spacer()
            
            Button {
                if acceptedTerms && name.count > 2 {
                    username = name
                    showTerms = false
                }
            } label: {
                Text("Continue")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                    )
            }

        }
        .padding(.horizontal)
    }
}

#Preview {
    TermsView(showTerms: .constant(true))
    
}
