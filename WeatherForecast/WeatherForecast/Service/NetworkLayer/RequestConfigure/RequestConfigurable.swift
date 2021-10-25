//
//  ParameterEncoding.swift
//  WeatherForecast
//
//  Created by yun on 2021/09/28.
//

import Foundation

protocol RequestConfigurable {
    static func configure(urlRequest: inout URLRequest, with parameter: Parameters) throws
}

enum NetworkError: LocalizedError {
    case encodingFailed
    case urlMissing
    case unIdentified
    
    var description: String {
        switch self {

        case .encodingFailed:
            return "Parameter encoding fail."
        case .urlMissing:
            return "URL is missing."
        case .unIdentified:
            return "Error can't be identified."
        }
    }
}
