//
//  HTTPPath.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/13.
//

import Foundation

//api.openweathermap.org/data/2.5/forecast
//api.openweathermap.org/data/2.5/weather
//openweathermap.org/img/w/01d.png

enum BaseURL: String {
    case weatherIcon = "https://openweathermap.org"
    case forecast, current = "https://api.openweathermap.org"
}

enum URLPathOptions {
    case current
    case forecast
    case weatherIcon
    
    enum Paths: String {
        case data = "data"
        case forecast = "forecast"
        case current = "weather"
        case img = "img"
        case w = "w"
        case twoPointFive = "2.5"
    }
    
    var paths: [String] {
        switch self {
        case .forecast:
            return ["\(Paths.data)", "\(Paths.twoPointFive)", "\(Paths.forecast)"]
        case .current:
            return ["\(Paths.data)", "\(Paths.twoPointFive)", "\(Paths.current)"]
        case .weatherIcon:
            return ["\(Paths.img)", "\(Paths.w)"]
        }
    }
}
