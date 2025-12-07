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
        let calendarView = CalendarView()
        let days = await calendarView.daysInMonth()
        #expect(days.notEmpty)
    }

}

extension Array {
    public var notEmpty: Bool {
        !isEmpty
    }
}
