//
//  Date Ext.swift
//  ToDo List
//
//  Created by Евгений Пашко on 10.12.2021.
//

import Foundation

// Make awesome Date String 
extension Date {
    var formattedDate: String {
        let formatted = DateFormatter()
        formatted.locale = .current
        formatted.dateStyle = .short
        formatted.timeStyle = .none
        formatted.dateFormat = "dd MMMM yyyy"
        return formatted.string(from: self)
    }
}
