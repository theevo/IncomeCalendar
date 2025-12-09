//
//  IncomeBudgeterTests.swift
//  IncomeBudgeterTests
//
//  Created by Tana Vora on 12/7/25.
//

import Foundation
import Testing
@testable import IncomeBudgeter

struct CalendarViewTests {
    let calendar = Calendar.current
    
    @Test func calendarRangeStartsOneWeekBeforeFirstDayOfMonth() {
        let calendarView = CalendarView()
        let (start, _) = calendarView.calendarRange()
        
        let components = calendar.dateComponents([.year, .month, .day], from: start)
        #expect(components.year == 2025)
        #expect(components.month == 11)
        #expect(components.day == 23)
    }
    
    @Test func calendarRangeEndsOneWeekAfterLastDayOfMonth() {
        let calendarView = CalendarView()
        let (_, end) = calendarView.calendarRange()
        
        let components = calendar.dateComponents([.year, .month, .day], from: end)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 10)
    }
    
    @Test func calendarRangeStartsOnSunday() {
        let calendarView = CalendarView()
        let (start, _) = calendarView.calendarRange()
        
        let weekday = calendar.component(.weekday, from: start)
        #expect(weekday == 1)
    }
    
    @Test func calendarRangeEndsOnSaturday() {
        let calendarView = CalendarView()
        let (_, end) = calendarView.calendarRange()
        
        let weekday = calendar.component(.weekday, from: end)
        #expect(weekday == 7)
    }
    
    @Test func allDatesReturnsExactlyFortyNineDays() {
        let calendarView = CalendarView()
        let dates = calendarView.allDates()
        
        #expect(dates.count == 49)
    }
    
    @Test func allDatesAreConsecutive() {
        let calendarView = CalendarView()
        let dates = calendarView.allDates()
        
        for i in 0..<dates.count - 1 {
            let diff = calendar.dateComponents([.day], from: dates[i], to: dates[i + 1])
            #expect(diff.day == 1)
        }
    }
    
    @Test func weeksReturnsSevenWeeks() {
        let calendarView = CalendarView()
        let weeks = calendarView.weeks()
        
        #expect(weeks.count == 7)
    }
    
    @Test func eachWeekHasSevenDays() {
        let calendarView = CalendarView()
        let weeks = calendarView.weeks()
        
        for week in weeks {
            #expect(week.count == 7)
        }
    }
    
    @Test func firstWeekStartsWithNovemberTwentyThird() {
        let calendarView = CalendarView()
        let weeks = calendarView.weeks()
        
        let firstDate = weeks[0][0]!
        let components = calendar.dateComponents([.year, .month, .day], from: firstDate)
        #expect(components.year == 2025)
        #expect(components.month == 11)
        #expect(components.day == 23)
    }
    
    @Test func lastWeekEndsWithJanuaryTenth() {
        let calendarView = CalendarView()
        let weeks = calendarView.weeks()
        
        let lastDate = weeks[6][6]!
        let components = calendar.dateComponents([.year, .month, .day], from: lastDate)
        #expect(components.year == 2026)
        #expect(components.month == 1)
        #expect(components.day == 10)
    }
    
    @Test func decemberFirstIsOnMonday() {
        let calendarView = CalendarView()
        let weeks = calendarView.weeks()
        
        let dec1 = weeks[1][1]!
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: dec1)
        #expect(components.year == 2025)
        #expect(components.month == 12)
        #expect(components.day == 1)
        #expect(components.weekday == 2)
    }
    
    @Test func decemberThirtyFirstIsOnWednesday() {
        let calendarView = CalendarView()
        let weeks = calendarView.weeks()
        
        let dec31 = weeks[5][3]!
        let components = calendar.dateComponents([.year, .month, .day, .weekday], from: dec31)
        #expect(components.year == 2025)
        #expect(components.month == 12)
        #expect(components.day == 31)
        #expect(components.weekday == 4)
    }
    
    @Test func isInCurrentMonthReturnsTrueForDecemberDates() {
        let calendarView = CalendarView()
        let dec15 = calendar.date(from: DateComponents(year: 2025, month: 12, day: 15))!
        
        #expect(calendarView.isInCurrentMonth(dec15) == true)
    }
    
    @Test func isInCurrentMonthReturnsFalseForNovemberDates() {
        let calendarView = CalendarView()
        let nov30 = calendar.date(from: DateComponents(year: 2025, month: 11, day: 30))!
        
        #expect(calendarView.isInCurrentMonth(nov30) == false)
    }
    
    @Test func isInCurrentMonthReturnsFalseForJanuaryDates() {
        let calendarView = CalendarView()
        let jan5 = calendar.date(from: DateComponents(year: 2026, month: 1, day: 5))!
        
        #expect(calendarView.isInCurrentMonth(jan5) == false)
    }
    
    @Test func isInCurrentMonthReturnsTrueForFirstDayOfMonth() {
        let calendarView = CalendarView()
        let dec1 = calendar.date(from: DateComponents(year: 2025, month: 12, day: 1))!
        
        #expect(calendarView.isInCurrentMonth(dec1) == true)
    }
    
    @Test func isInCurrentMonthReturnsTrueForLastDayOfMonth() {
        let calendarView = CalendarView()
        let dec31 = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!
        
        #expect(calendarView.isInCurrentMonth(dec31) == true)
    }
}
