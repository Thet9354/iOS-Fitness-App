//
//  Date+Ext.swift
//  Fitness App
//
//  Created by Phoon Thet Pine on 3/4/25.
//

import Foundation

/// Extension to add a computed property for getting the start of the current day
extension Date {
    
    // Returns the start of the current day
    static var startOfDay: Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: Date()) // return the start of the current day
    }
    
    /// Returns the start of the current week (Monday as start day)
    static var startOfWeek: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())
        components.weekday = 2
        return calendar.date(from: components) ?? Date()
    }
    
    /// Returns the start and end dates of the month for the given date.
    /// - Returns: A tuple containing the first day and the last day of the month.
    func fetchMonthStartAndEndDate() -> (Date, Date) {
        let calendar = Calendar.current
        
        // Extract the year and month components from the current date
        let startDateComponent = calendar.dateComponents([.year, .month], from: calendar.startOfDay(for: self))
        
        // Construct the first day of the month using the extracted components
        let startDate = calendar.date(from: startDateComponent) ?? self
        
        // Compute the last day of the month by adding 1 month and subtracting 1 day from the start date
        let endDate = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startDate) ?? self
        
        return (startDate, endDate)
    }
    
    /// Formats a date for workout display (e.g., "MM d").
    /// Returns: A formatted date string
    func formatWorkoutDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM d"
        return formatter.string(from: self)
    }
    
    func mondayDateFormat() -> String {
        let monday = Date.startOfWeek
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: monday)
    }
}
