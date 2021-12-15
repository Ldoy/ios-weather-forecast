//
//  NumberFormatter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/21.
//

import Foundation

extension NumberFormatter {
    static func customTemperatureFormatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        formatter.roundingMode = .halfUp
        formatter.numberStyle = .decimal
        return formatter
    }
}
