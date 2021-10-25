//
//  NetworkRouter.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/09/28.
//

import Foundation

protocol NetworkRouter {
    associatedtype EndPointType = EndPoint
    
    func request(_ route: EndPointType, _ session: URLSession, _ completionHandler: @escaping (Data) -> ())
    func cancel()
}

final class Router<EndPointType: EndPoint>: NetworkRouter {
    private var task: URLSessionDataTask?
    
    func request(_ route: EndPointType, _ session: URLSession, _ completionHandler: @escaping (Data) -> ()) {
        let request = self.buildRequest(from: route)
        
        task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error in
            guard let `self` = self else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, self.checkStatusCode(response: response) else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            completionHandler(data)
        })
        
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    private func checkStatusCode(response: HTTPURLResponse) -> Bool {
        switch response.statusCode {
        case 200:
            return true
        case 400:
            print("잘못된 요청입니다.")
            return false
        case 401:
            print("인증이 잘못되었습니다.")
            return false
        case 403:
            print("해당 정보에 접근할 수 없습니다. ")
            return false
        case 500...:
            print("서버에러")
            return false
        default:
            print("네트워크 요청을 확인 해 보세요")
            return false
        }
    }
    
    private func buildRequest(from route: EndPointType) -> URLRequest {
        var request = URLRequest(url: route.baseUrl)
        request.url?.appendPathComponent(route.path.rawValue, isDirectory: false)
        
        switch route.httpTask {
        case .request(withUrlParameters: let urlParameter):
            do {
                try URLManager.configure(urlRequest: &request, with: urlParameter)
            } catch {
                print(error)
            }
        }

        return request
    }
}
