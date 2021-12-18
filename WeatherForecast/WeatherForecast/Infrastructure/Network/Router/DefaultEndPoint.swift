//
//  EndPoint.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

struct DefaultEndPoint: EndPointable {
    var httpMethod: HTTPMethod
    var queryItems: QueryItems?
    var path: OpenWeatherPaths
}
