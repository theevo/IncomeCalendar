//
//  ContentView.swift
//  IncomeBudgeter
//
//  Created by Tana Vora on 12/7/25.
//

import SwiftUI

struct CalendarView: View {
    let year: Int = 2025
    let month: Int = 12
    let calendar = Calendar.current
    let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    
    // Get the start and end dates for the calendar view
    func calendarRange() -> (start: Date, end: Date) {
        let components = DateComponents(year: year, month: month, day: 1)
        let firstOfMonth = calendar.date(from: components)!
        
        // Find the first Sunday on or before the first of the month
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let daysToSubtract = weekday - 1 // Sunday = 1, so subtract (weekday - 1)
        let firstSunday = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstOfMonth)!
        
        // Add one full week before that Sunday
        let startDate = calendar.date(byAdding: .day, value: -7, to: firstSunday)!
        
        // Find last day of month
        let range = calendar.range(of: .day, in: .month, for: firstOfMonth)!
        let lastDayOfMonth = range.count
        let lastOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: lastDayOfMonth))!
        
        // Find the last Saturday on or after the last of the month
        let lastWeekday = calendar.component(.weekday, from: lastOfMonth)
        let daysToAdd = 7 - lastWeekday // Saturday = 7
        let lastSaturday = calendar.date(byAdding: .day, value: daysToAdd, to: lastOfMonth)!
        
        // Add one full week after that Saturday
        let endDate = calendar.date(byAdding: .day, value: 7, to: lastSaturday)!
        
        return (startDate, endDate)
    }
    
    // Generate all dates from start to end
    func allDates() -> [Date] {
        let (start, end) = calendarRange()
        var dates: [Date] = []
        var current = start
        while current <= end {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        return dates
    }
    
    // Organize dates into weeks
    func weeks() -> [[Date?]] {
        let dates = allDates()
        var weeks: [[Date?]] = []
        var currentWeek: [Date?] = []
        
        for date in dates {
            currentWeek.append(date)
            if currentWeek.count == 7 {
                weeks.append(currentWeek)
                currentWeek = []
            }
        }
        
        return weeks
    }
    
    // Check if date is in current month
    func isInCurrentMonth(_ date: Date) -> Bool {
        let dateMonth = calendar.component(.month, from: date)
        let dateYear = calendar.component(.year, from: date)
        return dateMonth == month && dateYear == year
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header row
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .border(Color.gray)
                }
            }
            ForEach(weeks(), id: \.self) { week in
                HStack(spacing: 0) {
                    ForEach(week.indices, id: \.self) { idx in
                        if let date = week[idx] {
                            let day = calendar.component(.day, from: date)
                            Text("\(day)")
                                .foregroundColor(isInCurrentMonth(date) ? .primary : .secondary)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .border(Color.gray)
                        }
                    }
                }
            }
        }
        .background(Color.clear)
        .border(Color.gray)
        .padding()
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("December 2025")
                .font(.title)
            CalendarView()
        }
        .padding(24)
    }
}

#Preview {
    ContentView()
}
