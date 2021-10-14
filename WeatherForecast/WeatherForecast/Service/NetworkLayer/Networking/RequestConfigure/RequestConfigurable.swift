//
//  ParameterEncoding.swift
//  WeatherForecast
//
//  Created by yun on 2021/09/28.
//

import Foundation

//protocol RequestConfigurable {
//    static func configure(urlRequest: inout URLRequest,
//                          with urlQueryItems: Parameters?,
//                          and pathComponents: URLPathParameters?) throws
//}

enum OpenWeatherError: LocalizedError {
    case encodingFailed
    case urlInvalid
    case unIdentified
    
    var description: String {
        switch self {
        case .encodingFailed:
            return "Parameter encoding fail."
        case .urlInvalid:
            return "URL is missing."
        case .unIdentified:
            return "Error can't be identified."
        }
    }
}
