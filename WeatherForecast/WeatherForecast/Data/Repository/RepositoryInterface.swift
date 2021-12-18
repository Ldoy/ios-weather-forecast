//
//  RepositoryInterface.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/12/17.
//

import Foundation
import CoreLocation.CLLocation

protocol Repository: AnyObject {
    associatedtype Storage
    var service: NetworkService { get set }
    var storage: Storage { get set }
}

