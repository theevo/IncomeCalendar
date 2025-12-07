//
//  Date+Extension.swift
//  IncomeBudgeter
//
//  Created by Tana Vora on 12/7/25.
//

import Foundation

extension Date {
    var dayInt: Int {
        Calendar.current.component(.day, from: self)
    }
}
