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
    
    // Helper to get all days in the month
    func daysInMonth() -> [Date] {
        let components = DateComponents(year: year, month: month)
        let startOfMonth = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        return range.compactMap { day -> Date? in
            calendar.date(from: DateComponents(year: year, month: month, day: day))
        }
    }
    
    // Helper to organize days into weeks
    func weeks() -> [[Int?]] {
        let days = daysInMonth()
        var weeks: [[Int?]] = []
        var currentWeek: [Int?] = Array(repeating: nil, count: 7)
        for day in days {
            let weekday = calendar.component(.weekday, from: day) - 1 // Sunday = 1
            if weeks.isEmpty && weekday != 0 {
                // Fill leading empty days
                for i in 0..<weekday {
                    currentWeek[i] = nil
                }
            }
            currentWeek[weekday] = calendar.component(.day, from: day)
            if weekday == 6 {
                weeks.append(currentWeek)
                currentWeek = Array(repeating: nil, count: 7)
            }
        }
        // Append last week if not empty
        if currentWeek.contains(where: { $0 != nil }) {
            weeks.append(currentWeek)
        }
        return weeks
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header row
            HStack(spacing: 0) {
                ForEach(daysOfWeek, id: \ .self) { day in
                    Text(day)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .border(Color.gray)
                }
            }
            ForEach(weeks(), id: \ .self) { week in
                HStack(spacing: 0) {
                    ForEach(week.indices, id: \ .self) { idx in
                        Group {
                            if let day = week[idx] {
                                Text("\(day)")
                                    .frame(maxWidth: .infinity, minHeight: 40)
                            } else {
                                Text("")
                                    .frame(maxWidth: .infinity, minHeight: 40)
                            }
                        }
                        .border(Color.gray)
                    }
                }
            }
        }
        .padding()
        .background(Color.clear)
        .border(Color.gray)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Text("December 2025")
                .font(.title)
                .padding(.bottom, 8)
            CalendarView()
        }
        .padding()
    }
}

/// Show Light and Dark side by side: click Variants in the Preview canvas and select Color Scheme Variants
#Preview {
    ContentView()
}
