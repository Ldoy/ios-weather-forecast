//
//  LocationButton.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit

enum LocationDataState {
    case fetchable
    case disFetchable
    
    var buttonTitle: String {
        switch self {
        case .fetchable:
            return "위치설정"
        case .disFetchable:
            return "위치변경"
        }
    }
}
