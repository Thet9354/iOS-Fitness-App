//
//  FitnessProfileEditButtonView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 4/4/25.
//

import SwiftUI

struct FitnessProfileEditButtonView: View {
    
    // MARK: VARIABLES
    @State var title: String
    @State var backgroundColor: Color
    var action: (() -> Void)

    
    var body: some View {
        Button {
            action()
        } label: {
            Text(title)
                .padding()
                .frame(maxWidth: 200)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(backgroundColor)
                )
        }
    }
}

#Preview {
    FitnessProfileEditButtonView(title: "", backgroundColor: .red) {}
}
