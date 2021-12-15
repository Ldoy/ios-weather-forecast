//
//  EndPoint.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation
typealias QueryItems = [String: Any]
typealias PathComponents = [String]

protocol EndPoint {
    var requestPurpose: RequestPurpose { get }
    var httpMethod: HTTPMethod { get }
    var urlElements: URLElements { get }
}

struct OpenWeatherAPI: EndPoint {
    var requestPurpose: RequestPurpose
    var httpMethod: HTTPMethod
    var urlElements: URLElements
}

enum URLElements {
    case with(_ : QueryItems?, and: PathComponents?)
}
