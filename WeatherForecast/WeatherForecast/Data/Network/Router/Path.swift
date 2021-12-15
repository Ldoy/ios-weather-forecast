//
//  Path.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/23.
//

import Foundation

enum PathOptions {
    case current
    case forecast
    
    enum PathComponents: String {
        case data, forecast
        case current = "weather"
        case twoPointFive = "2.5"
    }
    
    var fullPaths: [String] {
        switch self {
        case .forecast:
            return ["\(PathComponents.data)", "\(PathComponents.twoPointFive.rawValue)", "\(PathComponents.forecast)"]
        case .current:
            return ["\(PathComponents.data)", "\(PathComponents.twoPointFive.rawValue)", "\(PathComponents.current.rawValue)"]
        }
    }
}
