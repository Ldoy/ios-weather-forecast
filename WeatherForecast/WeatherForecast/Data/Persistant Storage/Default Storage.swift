//
//  Defatul Storage.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/12/17.
//

import Foundation

final class DefaultStorage: Storage {
    // 현재날씨, 미래날씨, 등등의 경우
    typealias Entity = CurrentWeather
    var data: CurrentWeather?
    func save(from parsedData: Entity) {
        
    }
}
