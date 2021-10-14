//
//  HTTPTask.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation
typealias QueryParameters = [String: Any]
typealias URLPathParameters = [String]

enum HTTPTask {
    case request(withPathComponents: URLPathParameters)
    case request(withURLQueryItems: QueryParameters,
                 withPathComponents: URLPathParameters)
}
