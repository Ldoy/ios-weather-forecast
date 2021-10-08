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

struct FiveDaysForecast: Decodable {
    var list: [ListDetail]
}

struct ListDetail: Decodable {
    var date: Int
    var main: MainDetail
    var weather: [WeatherDetail]

    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main, weather
    }
}

struct MainDetail: Decodable {
    var temperature: Double

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
    }
}

struct WeatherDetail: Decodable {
    var icon: String
}

