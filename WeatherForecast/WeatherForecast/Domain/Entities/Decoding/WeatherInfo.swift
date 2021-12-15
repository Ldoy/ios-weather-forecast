//
//  WeatherInfoModel.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/29.
//

import Foundation

struct Parser {
    private let decoder = JSONDecoder()
    
    func decode<Model: Decodable>(_ data: Data, to model: Model.Type) throws -> Model {
        do {
            let parsedData = try decoder.decode(model, from: data)
            return parsedData
        } catch DecodingError.dataCorrupted(let context) {
            throw DecodingError.dataCorrupted(context)
        } catch DecodingError.keyNotFound(let codingKey, let context) {
            throw DecodingError.keyNotFound(codingKey, context)
        } catch DecodingError.typeMismatch(let type, let context) {
            throw DecodingError.typeMismatch(type, context)
        } catch DecodingError.valueNotFound(let value, let context) {
            throw DecodingError.valueNotFound(value, context)
        }
    }
}

struct FiveDaysForecastData: Decodable {
    var list: [ForcastInfomation]
}

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
