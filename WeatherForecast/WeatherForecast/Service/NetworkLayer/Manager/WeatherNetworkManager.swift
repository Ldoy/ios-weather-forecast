//
//  WeatherApi.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation


struct Holder {
    var forcast: FiveDaysForecastData?
    var current: CurrentWeather?
    
    init(_ path: Path, _ data: Data) {
        switch path {
        case .forecast:
            do {
                let decodedData = try  Parser().decode(data, to: FiveDaysForecastData.self)
                self.forcast = decodedData
            } catch {
                print(error)
            }
        case .weather:
            do {
                let decodedData = try  Parser().decode(data, to: CurrentWeather.self)
                self.current = decodedData
            } catch {
                print(error)
            }
        }
    }
}

final class WeatherNetworkManager {
    private let router = Router<OpenWeatherApi>()
    static let apiKey = "9cda367698143794391817f65f81c76e"

    func fetchData(requiredApi: OpenWeatherApi, _ session: URLSession, _ completionHandler: @escaping (Holder) -> ()) {
        
        router.request(requiredApi, session) { data in
            let result = Holder(requiredApi.path, data)
            completionHandler(result)
        }
    }
}
