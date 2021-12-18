//
//  CurrentWeather.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/12/17.
//

import Foundation

struct CurrentWeather: Decodable {
    var coordination: Coordinate
    var weather: [Weather]
    var main: Temperature
    var date: Int
    
    enum CodingKeys: String, CodingKey {
        case coordination = "coord"
        case weather, main
        case date = "dt"
    }
    
    struct Weather: Decodable {
        var icon: String
    }
    
    struct Temperature: Decodable {
        var currentTemperature: Double
        var temperatureMinimum: Double
        var temperatureMaximum: Double
        
        enum CodingKeys: String, CodingKey {
            case currentTemperature = "temp"
            case temperatureMinimum = "temp_min"
            case temperatureMaximum = "temp_max"
        }
    }
    
    struct Coordinate: Decodable {
        var longitude: Double
        var lattitude: Double
        
        enum CodingKeys: String, CodingKey {
            case longitude = "lon"
            case lattitude = "lat"
        }
    }
}
