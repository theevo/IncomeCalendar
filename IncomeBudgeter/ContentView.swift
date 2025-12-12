//  ContentView.swift
//  IncomeBudgeter
//
//  Created by Tana Vora on 12/7/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct CalendarView: View {
    @Binding var year: Int
    @Binding var month: Int
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
    @State private var year: Int = 2026
    @State private var month: Int = 1
    @State private var isExporting: Bool = false
    
    var label: String {
        let calendar = Calendar.current
        let components = DateComponents(year: year, month: month, day: 1)
        let firstOfMonth = calendar.date(from: components)!
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: firstOfMonth)
    }
    
    var fileName: String {
        "Calendar_\(year)_\(String(format: "%02d", month)).csv"
    }
    
    // Generate CSV content for the current month
    func generateCSV() -> String {
        let calendar = Calendar.current
        let daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        
        // Start with header row
        var csv = daysOfWeek.joined(separator: ",") + "\n"
        
        // Get calendar range
        let components = DateComponents(year: year, month: month, day: 1)
        let firstOfMonth = calendar.date(from: components)!
        
        // Find the first Sunday on or before the first of the month
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let daysToSubtract = weekday - 1
        let firstSunday = calendar.date(byAdding: .day, value: -daysToSubtract, to: firstOfMonth)!
        let startDate = calendar.date(byAdding: .day, value: -7, to: firstSunday)!
        
        // Find last day of month
        let range = calendar.range(of: .day, in: .month, for: firstOfMonth)!
        let lastDayOfMonth = range.count
        let lastOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: lastDayOfMonth))!
        
        // Find the last Saturday on or after the last of the month
        let lastWeekday = calendar.component(.weekday, from: lastOfMonth)
        let daysToAdd = 7 - lastWeekday
        let lastSaturday = calendar.date(byAdding: .day, value: daysToAdd, to: lastOfMonth)!
        let endDate = calendar.date(byAdding: .day, value: 7, to: lastSaturday)!
        
        // Generate dates
        var dates: [Date] = []
        var current = startDate
        while current <= endDate {
            dates.append(current)
            current = calendar.date(byAdding: .day, value: 1, to: current)!
        }
        
        // Organize into weeks and add to CSV
        var currentWeek: [String] = []
        for date in dates {
            let day = calendar.component(.day, from: date)
            currentWeek.append("\(day)")
            
            if currentWeek.count == 7 {
                csv += currentWeek.joined(separator: ",") + "\n"
                currentWeek = []
            }
        }
        
        return csv
    }
    
    // Export CSV file
    func exportCSV() {
        isExporting = true
    }
    
    // Create a temporary document for export
    func createCSVDocument() -> CSVDocument {
        return CSVDocument(content: generateCSV())
    }
    
    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    if month == 1 {
                        month = 12
                        year -= 1
                    } else {
                        month -= 1
                    }
                }) {
                    Image(systemName: "lessthan.circle.fill")
                        .font(.title)
                }
                
                Spacer()
                
                Text(label)
                    .font(.title)
                
                Spacer()
                
                Button(action: {
                    if month == 12 {
                        month = 1
                        year += 1
                    } else {
                        month += 1
                    }
                }) {
                    Image(systemName: "greaterthan.circle.fill")
                        .font(.title)
                }
            }
            .padding(.horizontal)
            
            CalendarView(year: $year, month: $month)
            
            // Export Button
            Button(action: {
                exportCSV()
            }) {
                Label("Export", systemImage: "square.and.arrow.up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.top, 8)
        }
        .padding(24)
        .fileExporter(
            isPresented: $isExporting,
            document: createCSVDocument(),
            contentType: .commaSeparatedText,
            defaultFilename: fileName
        ) { result in
            switch result {
            case .success(let url):
                print("CSV exported successfully to \(url)")
            case .failure(let error):
                print("Error exporting CSV: \(error.localizedDescription)")
            }
        }
    }
}

// Document type for CSV export
struct CSVDocument: FileDocument {
    static var readableContentTypes: [UTType] { [.commaSeparatedText] }
    
    var content: String
    
    init(content: String) {
        self.content = content
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents,
           let string = String(data: data, encoding: .utf8) {
            content = string
        } else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = content.data(using: .utf8)!
        return FileWrapper(regularFileWithContents: data)
    }
}

#Preview {
    ContentView()
}
