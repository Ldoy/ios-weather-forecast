//
//  Parser.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/12/17.
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
