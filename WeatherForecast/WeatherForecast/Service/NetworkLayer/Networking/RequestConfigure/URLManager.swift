//
//  URLParameterEncoder.swift
//  WeatherForecast
//
//  Created by yun on 2021/09/29.
//

import Foundation

class URLManager {
    
    static func configure(urlRequest: inout URLRequest,
                          with urlQueryItems: QueryParameters?,
                          and pathComponents: URLPathParameters?) throws {
        guard let url = urlRequest.url else {
            throw OpenWeatherError.urlInvalid
        }
       
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            return
        }
        
        insert(pathComponents: pathComponents, to: &urlComponents)
        insert(queryItems: urlQueryItems, to: &urlComponents)
        urlRequest.url = urlComponents.url
    }
    
    static private func insert(queryItems: QueryParameters?,
                               to urlComponents: inout URLComponents) {
        guard let queryItems = queryItems else {
            return
        }
        
        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
    }
    
    static private func insert(pathComponents: URLPathParameters?,
                               to urlComponents: inout URLComponents) {
        guard let pathComponents = pathComponents else {
            return
        }
        
        for key in pathComponents {
            urlComponents.path.append(key)
        }
    }
//    static func configure(urlRequest: inout URLRequest,
//                          with urlQueryItems: Parameters?,
//                          and pathComponents: URLPathParameters?) throws {
//        guard let url = urlRequest.url else {
//            throw OpenWeatherError.urlInvalid
//        }
//
//        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
//            return
//        }
//
//        insert(pathComponents: pathComponents, to: &urlComponents)
//        insert(queryItems: urlQueryItems, to: &urlComponents)
//        urlRequest.url = urlComponents.url
//    }
//
//    static private func insert(queryItems: Parameters?,
//                               to urlComponents: inout URLComponents) {
//        guard let queryItems = queryItems else {
//            return
//        }
//
//        for (key, value) in queryItems {
//            let queryItem = URLQueryItem(name: key, value: "\(value)")
//            urlComponents.queryItems?.append(queryItem)
//        }
//    }
//
//    static private func insert(pathComponents: URLPathParameters?,
//                               to urlComponents: inout URLComponents) {
//        guard let pathComponents = pathComponents else {
//            return
//        }
//
//        for key in pathComponents {
//            urlComponents.path.append(key)
//        }
//    }
}

