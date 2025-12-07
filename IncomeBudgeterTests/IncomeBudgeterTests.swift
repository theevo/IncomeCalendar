//
//  IncomeBudgeterTests.swift
//  IncomeBudgeterTests
//
//  Created by Tana Vora on 12/7/25.
//

import Testing
@testable import IncomeBudgeter

struct CalendarViewTests {
    @Test func daysInMonth_notEmpty() async throws {
        let calendarView = await CalendarView()
        let days = await calendarView.daysInMonth()
        #expect(days.notEmpty)
    }
    
    @Test func daysInMonth_startWith1() async throws {
        let calendarView = await CalendarView()
        let days = await calendarView.daysInMonth()
        #expect(days.first?.dayInt == 1)
    }
    
    @Test func weeks_startWith1() async throws {
        let calendarView = await CalendarView()
        let weeks = await calendarView.weeks()
        #expect(weeks.first?.contains(1) == true)
    }
}
