//
//  DateFomatterHelper.swift
//  MovieTV
//
//  Created by ZeroGravity on 2/12/21.
//  Copyright © 2021 ZeroGravity. All rights reserved.
//

import UIKit

struct DateFomatterHelper {
    
    enum DateFormatString: String {
//        MARK: Example format
///        case `[FORMAT_NAME]` = "`[FORMAT_VALUE]`"
        
        case UTC = "yyyy-MM-dd HH:mm:ss UTC"
        case year_month_day_dash = "yyyy-MM-dd"
        case year = "yyyy"
        case day_month_year = "d MMM yyyy"
    }
    
    static func changeDateFormat(from fromDate: String?, fromFormat: DateFormatString = .UTC, timeZone: TimeZone? = TimeZone.current, toFormat: DateFormatString) -> String {
        guard let fromDate = fromDate, let timeZone = timeZone, !fromDate.isEmpty else {return ""}
        
        let formatter = DateFormatter()
        formatter.dateFormat = fromFormat.rawValue //2017-04-01T18:05:00.000
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: fromDate) else {return ""}
        
        formatter.timeZone = timeZone
        formatter.dateFormat = toFormat.rawValue
        let resultTime = formatter.string(from: date)
        return resultTime
    }
    
    static func changeDateFormat(from fromDate: Date?, toFormat: DateFormatString) -> String {
        guard let fromDate = fromDate else {return ""}
        
        let formatter = DateFormatter()
        formatter.dateFormat = toFormat.rawValue //2017-04-01T18:05:00.000
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: fromDate)
    }
    
    static func getDate(from dateString: String?, dateStringFormat: DateFormatString = .UTC, timeZone: TimeZone? = .current) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = dateStringFormat.rawValue //2017-04-01T18:05:00.000
        formatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = formatter.date(from: dateString ?? "") else {return nil}
        
        return date
    }
}
