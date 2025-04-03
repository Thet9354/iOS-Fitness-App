//
//  Double+Ext.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 2/4/25.
//

import Foundation

/// Extension to format numbers for display
extension Double {
    
    /// Formats a number as a string with no decimal places.
    /// - Returns: A formatted string representation of the number
    func formattedNumberString() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
