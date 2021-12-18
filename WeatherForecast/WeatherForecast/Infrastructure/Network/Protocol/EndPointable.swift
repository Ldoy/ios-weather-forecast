//
//  NetworkInterface.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/12/15.
//

import Foundation
typealias QueryItems = [String: Any?]

protocol EndPointable {
    var httpMethod: HTTPMethod { get }
    var queryItems: QueryItems? { get }
    var path: OpenWeatherPaths { get }
//    var openWeatherUrl: OpenWeatherURL? { get }
}

enum OpenWeatherPaths: String {
    case threHours5Days = "data/2.5/forecast"
    case currentWeather = "data/2.5/weather"
}

