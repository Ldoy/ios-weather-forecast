//
//  NetworkRouter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

protocol NetworkRouter {
    associatedtype EndPointType = EndPoint
    
    func request(with route: EndPointType, and session: URLSession)
    func cancel()
}

final class Router<EndPointType: EndPoint>: NetworkRouter {
    private var task: URLSessionDataTask?
    
    func request(with route: EndPointType, and session: URLSession) {
        do {
            let request = try self.buildRequest(from: route)
            task = session.dataTask(with: request)
            self.task?.resume()
        } catch {
            print(error)
        }
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPointType) throws -> URLRequest {
        guard let url = self.generateBaseURL(route.requestPurpose) else {
            throw NetworkError.invalidURL
        }
        var request = URLRequest(url: url)
        
        switch route.urlElements {
        case .with(let query, and: let path):
            insert(pathComponents: path, to: &request)
            insert(queryItems: query, to: &request)
        }
        
        return request
    }
    
    private func insert(queryItems: QueryItems?,
                        to urlRequest: inout URLRequest) {
        guard let queryItems = queryItems,
              let url = urlRequest.url,
              var urlComponents = URLComponents(
                url: url,
                resolvingAgainstBaseURL: false) else {
            return
        }
    
        urlComponents.queryItems = [URLQueryItem]()
        
        for (key, value) in queryItems {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            urlComponents.queryItems?.append(queryItem)
        }
        
        urlRequest.url = urlComponents.url
    }
    
    private func insert(pathComponents: PathComponents?,
                        to urlRequest: inout URLRequest) {
        guard let pathComponents = pathComponents else {
            return
        }
        
        for component in pathComponents {
            urlRequest.url?.appendPathComponent(component)
        }
    }
    
    private func generateBaseURL(_ purpose: RequestPurpose) -> URL? {
        var urlDescription = ""
        
        switch purpose {
        case .currentWeather, .forecast:
            urlDescription = "https://api.openweathermap.org"
        }
        
        guard let url = URL(string: urlDescription) else {
            print(NetworkError.invalidURL.description)
            return nil
        }
        
        return url
    }
}
