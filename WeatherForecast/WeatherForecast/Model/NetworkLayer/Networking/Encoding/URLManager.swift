//
//  URLParameterEncoder.swift
//  WeatherForecast
//
//  Created by yun on 2021/09/29.
//

import Foundation

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

struct URLManager: RequestConfigurable {
    static func configure(urlRequest: inout URLRequest, with parameter: Parameters) throws {
        guard let url = urlRequest.url else {
            throw NetworkError.urlMissing
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
           !parameter.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key, value) in parameter {
                let queryItem = URLQueryItem(name: key, value: "\(value)")
                urlComponents.queryItems?.append(queryItem)
            }
            
            urlRequest.url = urlComponents.url
        }
    }
}

