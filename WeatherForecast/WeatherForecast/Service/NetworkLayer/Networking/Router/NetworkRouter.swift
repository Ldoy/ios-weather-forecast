//
//  NetworkRouter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation
import CoreLocation.CLLocationManager

protocol NetworkRouter {
    associatedtype EndPointType = EndPoint
    
    func request(_ route: EndPointType, _ session: URLSession)
    func cancel()
}

final class Router<EndPointType: EndPoint>: NetworkRouter {
    private var task: URLSessionDataTask?
    private var request: URLRequest?
    
    func request(_ route: EndPointType, _ session: URLSession) {
        do {
            self.request = try self.buildRequest(from: route)
        } catch {
            print(error)
        }
        
        task = session.dataTask(with: self.request)
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    // 위치를 받아서 요청하도록
    
    func buildApi(weatherOrCurrent: URLPathOptions, location: (latitude: CLLocationDegrees, longitude: CLLocationDegrees)) -> OpenWeatherApi? {
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5") else {
            return nil
        }

        let requestInfo: URLPathParameters = ["lat": location.latitude , "lon": location.longitude, "appid": WeatherNetworkManager.apiKey]

        let api = OpenWeatherApi(httpTask: .request(withUrlParameters: requestInfo), httpMethod: .get, baseUrl: url, path: weatherOrCurrent)

        return api
    }
    
    func buildRequest(from route: EndPointType) throws -> URLRequest  {
        guard let url = URL(string: route.baseUrl.rawValue) else {
            throw OpenWeatherError.urlInvalid
        }
        
        var request = URLRequest(url: url)
        let path = route.path.paths
        let query =
        do {
            try URLManager.configure(urlRequest: &request, with: <#T##Parameters?#>, and: path)
        } catch {
            
        }
        switch route.httpTask {
        case .request(withPathComponents: let path):
            do {
                try URLManager.configure(urlRequest: &request, with: nil, and: path)
            } catch {
                print(error)
            }
        case .request(withURLQueryItems: let urlQuery, withPathComponents: let path):
            do {
                try URLManager.configure(urlRequest: &request, with: nil, and: path)
            } catch {
                print(error)
            }
        }
        
//        switch route.httpTask {
//        case .request(withPathComponents: let pathComponents) :
//            do {
//                try URLManager.configure(urlRequest: &request,
//                                         with: nil,
//                                         and: pathComponents)
//            } catch {
//                print(error)
//            }
//
//        case .request(withURLQueryItems: let urlQueryItem,
//                      withPathComponents: let pathComponents):
//            do {
//                try URLManager.configure(urlRequest: &request, with: urlQueryItem)
//            } catch {
//                print(error)
//            }
//        }
        return request
    }
}
