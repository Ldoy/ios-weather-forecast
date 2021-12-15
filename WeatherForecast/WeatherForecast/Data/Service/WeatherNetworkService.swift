//
//  WeatherApi.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation
import CoreLocation.CLLocationManager

typealias Location = (latitude: CLLocationDegrees, longitude: CLLocationDegrees)

func requestWeatherData(requestPurpose: RequestPurpose, location: Location?) {
    let sessionDelegate = OpenWeatherSessionDelegate()
    let networkService = WeatherNetworkService()
    
    networkService
        .fetchOpenWeatherData(latitudeAndLongitude: location,
                              requestPurpose: .currentWeather,
                              sessionDelegate.session)
    
    networkService
        .fetchOpenWeatherData(latitudeAndLongitude: location,
                              requestPurpose: .forecast,
                              sessionDelegate.session)
}

final class WeatherNetworkService {
    private let router = Router<OpenWeatherAPI>()
    private let apiKey = "9cda367698143794391817f65f81c76e"
    
    func fetchOpenWeatherData(latitudeAndLongitude: Location?,
                              requestPurpose: RequestPurpose,
                              _ session: URLSession) {
        let api = buildApi(location: latitudeAndLongitude,
                           requestPurpose: requestPurpose)
        router.request(with: api, and: session)
    }
    
    private func buildApi(location: Location?,
                          requestPurpose: RequestPurpose) -> OpenWeatherAPI {
        let query = maekQueryItems(requestPurpose, location)
        let path = maekPathComponents(requestPurpose)
        let api = OpenWeatherAPI(requestPurpose: requestPurpose,
                                 httpMethod: .get,
                                 urlElements: .with(query,and: path))
        return api
    }
    
    private func maekQueryItems(_ requestPurpose: RequestPurpose,
                                _ location: Location?) -> QueryItems? {
        switch requestPurpose {
        case .currentWeather, .forecast:
            guard let location = location else {
                return nil
            }
            
            return ["lat": location.latitude ,
                    "lon": location.longitude,
                    "appid": self.apiKey]
        }
    }
    
    private func maekPathComponents(_ requestPurpose: RequestPurpose) -> PathComponents {
        switch requestPurpose {
        case .currentWeather:
            return PathOptions.current.fullPaths
        case .forecast:
            return PathOptions.forecast.fullPaths
        }
    }
}
