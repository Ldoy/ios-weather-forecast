//
//  CellHolder.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/21.
//

import Foundation

final class CellHolder {
    private let dateLabelText: String
    private let temperatureText: String
    
    init(forcastInformation: FiveDaysForecastData) {
        let dateformatter = DateFormatter.customDateFormatter()
        let date = Date(timeIntervalSince1970: TimeInterval(forcastInformation.list.first?.date ?? .zero))
        let formattedDate = dateformatter.string(from: date)
        self.dateLabelText = formattedDate

        let formattedTemperature = TemperatureConverter(celciusTemperature: forcastInformation.list.first?.main.temperature ?? .zero).convertedTemperature
        self.temperatureText = "\(formattedTemperature)°"
    }
    
    var date: String {
        return self.dateLabelText
    }
    
    var temperature: String {
        return self.temperatureText
    }
}
