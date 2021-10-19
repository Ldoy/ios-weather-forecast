//
//  LocationManager.swift
//  WeatherForecast
//
//  Created by yun on 2021/10/05.
//

import CoreLocation.CLLocationManager

class LocationManager: CLLocationManager {
    var userState = UserState.able
    
    func askUserLocation() {
        self.requestWhenInUseAuthorization()
    }
    
    override init() {
        super.init()
        self.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }
}
