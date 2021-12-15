//
//  ParameterEncoding.swift
//  WeatherForecast
//
//  Created by yun on 2021/09/28.
//

import Foundation

enum NetworkError: LocalizedError {
    case encodingFailed
    case invalidURL
    case unIdentified
    
    var description: String {
        switch self {

        case .encodingFailed:
            return "Parameter encoding fail."
        case .invalidURL:
            return "URL is missing."
        case .unIdentified:
            return "Error can't be identified."
        }
    }
}
