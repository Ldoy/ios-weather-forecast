//
//  DataHolder.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/20.
//

import Foundation

final class WeatherDataHolder {
    static let shared = WeatherDataHolder()
    
    var forcast: FiveDaysForecastData?
    var current: CurrentWeather?
    
    private init() { }
    
    func generate(path: String, data: Data) {
        guard let path = PathOptions.PathComponents(rawValue: path) else {
            return
        }
        
        switch path {
        case .forecast :
            do {
                let decodedData = try  Parser().decode(data, to: FiveDaysForecastData.self)
                self.forcast = decodedData
            } catch {
                print(error)
            }
        case .current :
            do {
                let decodedData = try Parser().decode(data, to: CurrentWeather.self)
                self.current = decodedData
            } catch {
                print(error)
            }
            
        default:
            break
        }
        
        NotificationCenter
            .default
            .post(name: .stopRefresh,
                  object: nil)
    }
}
