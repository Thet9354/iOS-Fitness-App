//
//  ChartDataView.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 24/3/25.
//

import SwiftUI

struct ChartDataView: View {
    
    // MARK: VARIABLE
    @State var average: Int
    @State var total: Int
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(spacing: 16) {
                Text("Average")
                    .font(.title2)
                
                Text("\(average)")
                    .font(.title3)
            }
            .frame(width: 90)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
            
            VStack(spacing: 16) {
                Text("Total")
                    .font(.title2)
                
                Text("\(total)")
                    .font(.title3)
            }
            .frame(width: 90)
            .padding()
            .background(.gray.opacity(0.1))
            .cornerRadius(10)
            
            Spacer()
        }
    }
}

#Preview {
    ChartDataView(average: 123, total: 8461)
}
