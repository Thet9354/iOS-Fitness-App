//
//  FitnessProfileButtonView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 3/4/25.
//

import SwiftUI

struct FitnessProfileButtonView: View {
    
    // MARK: VARIABLE
    @State var title: String
    @State var image: String
    var action: (() -> Void)
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Image(systemName: image)
                
                Text(title)
            }
            .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    FitnessProfileButtonView(title: "Edit", image: "square.and.pencil") {}
}
