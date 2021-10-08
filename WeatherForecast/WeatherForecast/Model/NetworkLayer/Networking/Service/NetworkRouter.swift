//
//  NetworkRouter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

protocol NetworkRouter {
    associatedtype EndPointType = EndPoint
    
    func request<T>(_ route: EndPointType, _ session: URLSession, _ completionHandler: @escaping (T) -> ())
    func cancel()
}

final class Router<EndPointType: EndPoint>: NetworkRouter {
    private var task: URLSessionDataTask?
    var data: FiveDaysForecast?
    
    func request<Data>(_ route: EndPointType, _ session: URLSession, _ completionHandler: @escaping (Data) -> ()) {
        let request = self.buildRequest(from: route)
        
        guard let url = request.url else {
            return
        }
        
        task = session.dataTask(with: url) { data, response, error in
            guard error == nil else  {
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                return
            }
            
            guard let data = data as? Data else {
                return
            }
            
            completionHandler(data)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func buildRequest(from route: EndPointType) -> URLRequest {
        var request = URLRequest(url: route.baseUrl)
        
        switch route.httpTask {
        case .request(withUrlParameters: let urlParameter):
            self.configureRequestUrl(&request, urlParameter)
        }
        
        return request
    }
    
    private func configureRequestUrl(_ request: inout URLRequest, _ urlParameters: Parameters) {
        do {
            try URLManager.configure(urlRequest: &request, with: urlParameters)
        } catch {
            print(error)
        }
    }
}
