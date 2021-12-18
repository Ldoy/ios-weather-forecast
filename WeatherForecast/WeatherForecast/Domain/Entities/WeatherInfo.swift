//
//  WeatherInfoModel.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/29.
//

import Foundation

struct FiveDaysForecastData: Decodable {
    var list: [ForcastInfomation]
    
    struct ForcastInfomation: Decodable {
        var date: Int
        var main: Temperature
        var weather: [WeatherDetail]
        
        enum CodingKeys: String, CodingKey {
            case date = "dt"
            case main, weather
        }
        
        struct Temperature: Decodable {
            var temperature: Double
            
            enum CodingKeys: String, CodingKey {
                case temperature = "temp"
            }
        }
        
        struct WeatherDetail: Decodable {
            var icon: String
        }
    }

}
