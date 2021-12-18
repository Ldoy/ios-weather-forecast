//
//  WeatherApi.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation
import CoreLocation.CLLocationManager

typealias Location = (latitude: CLLocationDegrees, longitude: CLLocationDegrees)

protocol NetworkService: AnyObject {
    func request(with endPoint: EndPointable,
                 and session: URLSession)
    func cancel()
}

final class WeatherNetworkService: NetworkService {
    private var task: URLSessionDataTask?
    private let apiKey = "9cda367698143794391817f65f81c76e"
    
    func request(with endPoint: EndPointable,
                 and session: URLSession) {
        do {
            let request = try self.buildRequest(from: endPoint)
            task = session.dataTask(with: request)
            self.task?.resume()
        } catch {
            print(error)
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from endPoint: EndPointable) throws -> URLRequest {
        // url 만들기 
        guard let url = generateURL(from: endPoint) else {
            throw NetworkError.invalidURL
        }
        let request = URLRequest(url: url)

        return request
    }
    
    private func generateURL(from endPoint: EndPointable) -> URL? {
        let baseURL = "api.openweathermap.org"
        let url = baseURL + endPoint.path.rawValue
        
        guard let url = URL(string: url),
              var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else {
            print(#function, "에서 오류가 생겼습니다.")
            return nil
        }
        
        if let queryItems = endPoint.queryItems {
            return insert(to: &urlComponents, queryItems)
        } else {
            return url
        }
    }
    
    private func insert(to urlComponents: inout URLComponents, _ queryItems: QueryItems) -> URL? {
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key, value: "\(value ?? "🥲")")
            urlComponents.queryItems?.append(queryItem)
        }
        print(urlComponents.url?.description)
        return urlComponents.url
    }
}
