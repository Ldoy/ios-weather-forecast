//
//  SessionDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/13.
//

import Foundation
import UIKit.UIImage

final class OpenWeatherSessionDelegate: NSObject, URLSessionDataDelegate {
    lazy var session: URLSession = {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        return session
    }()
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if error != nil {
            print(error)
            return
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        let requestData = proposedResponse.data
        let pathCompnent = dataTask.currentRequest?.url?.pathComponents.last
        
        if let path = pathCompnent {
            WeatherDataHolder.shared.generate(path: path, data: requestData)
            NotificationCenter.default.post(name: .reloadTableView, object: nil)
        }
        
        completionHandler(proposedResponse)
    }
}
