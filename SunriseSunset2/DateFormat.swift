//
//  DateFormat.swift
//  SunriseSunset2
//
//  Created by user on 11/21/18.
//  Copyright © 2018 Chorniak inc. All rights reserved.
//

import Foundation

class DateFormat {
    func dateFormatter(time: String) -> String {
        
        let dateFormatter = DateFormatter()
        let tempLocale = dateFormatter.locale
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from: time)!
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = tempLocale
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
