//
//  DateFormatter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/21.
//

import Foundation

extension DateFormatter {
    static func customDateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "ko")
        formatter.setLocalizedDateFormatFromTemplate("MM/dd(E) HH시")
        return formatter
    }
}
