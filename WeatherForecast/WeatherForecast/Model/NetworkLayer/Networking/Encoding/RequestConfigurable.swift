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
