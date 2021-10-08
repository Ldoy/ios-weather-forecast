//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by yun on 2021/10/05.
//

import Foundation
import CoreLocation

class LocationManager: CLLocationManager {
    func askUserLocation() {
        self.requestWhenInUseAuthorization()
        self.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
}
