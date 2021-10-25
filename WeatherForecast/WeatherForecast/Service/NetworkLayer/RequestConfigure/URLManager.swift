//
//  URLParameterEncoder.swift
//  WeatherForecast
//
//  Created by yun on 2021/09/29.
//

import Foundation

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

