//
//  WeatherInfoList.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import Foundation
import CoreLocation.CLLocationManager

//protocol ApiModeling: AnyObject {
//    func buildApi(weatherOrCurrent: URLPathOptions, location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)) -> OpenWeatherApi?
//}
//
//extension ApiModeling {
//    func buildApi(weatherOrCurrent: URLPathOptions, location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)) -> OpenWeatherApi? {
//        guard let url = URL(string: "https://api.openweathermap.org/data/2.5") else {
//            return nil
//        }
//
//        let requestInfo: URLPathParameters = ["lat": location.latitude , "lon": location.longitude, "appid": WeatherNetworkManager.apiKey]
//
//        let api = OpenWeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: url, path: weatherOrCurrent)
//
//        return api
//    }
//}

