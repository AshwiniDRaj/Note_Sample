//
//  Date.swift
//  Notes_Sample
//
//  Created by Ashwini on 03/02/20.
//  Copyright © 2020 Ashwini. All rights reserved.
//

import Foundation

extension Date {
    static func convertDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let myString = formatter.string(from: date)
        let yourDate = formatter.date(from: myString)
        formatter.dateFormat = "EEEE, MMM d, yyyy, hh:mm:ss"
        let myStringafd = formatter.string(from: yourDate!)
        return myStringafd
    }
    
    static func convertDate(date: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy, hh:mm:ss"
        
        let formatedDate = formatter.date(from: date)!
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let formattedString = formatter.string(from: formatedDate)
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        let convertedDate = formatter.date(from: formattedString)
        return convertedDate!
    }

    static func convertDate(date: Date, format : String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let stringDate = formatter.string(from: date)
        return stringDate
    }

    static func convertDate(date: String, format : String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let formattedDate = formatter.date(from: date)
        return formattedDate
    }

    func firstDateOfMonth() -> Date {
        let calendar: Calendar = Calendar.current
        var components: DateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        components.setValue(1, for: .day)
        return calendar.date(from: components)!
    }

}
