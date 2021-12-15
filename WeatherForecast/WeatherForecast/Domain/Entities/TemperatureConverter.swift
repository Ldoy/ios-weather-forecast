//
//  TemperatureConverter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/18.
//

import Foundation

struct TemperatureConverter {
    let convertedTemperature: String
    
    init(celciusTemperature: Double) {
        let celsiusUnit = UnitTemperature.celsius
        let convertedTemperature = celsiusUnit.converter.value(fromBaseUnitValue: celciusTemperature)
        
        if let formattedTemperature = NumberFormatter.customTemperatureFormatter().string(for: convertedTemperature) {
            self.convertedTemperature = formattedTemperature
        } else {
            self.convertedTemperature = "🔥"
        }
    }
}
