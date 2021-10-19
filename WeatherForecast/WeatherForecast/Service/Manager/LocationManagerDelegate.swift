//
//  LocationManagerDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import CoreLocation.CLLocationManagerDelegate

class LocationManagerDelegate: NSObject, CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        guard let latitude = locations.last?.coordinate.latitude,
              let longitude = locations.last?.coordinate.longitude else {
            return
        }
        
        let location: Location = (latitude, longitude)
        let sessionDelegate = OpenWeatherSessionDelegate()
        let networkManager = WeatherNetworkManager()
        
        networkManager.fetchOpenWeatherData(latitudeAndLongitude: location,
                                            requestPurpose: .currentWeather,
                                            sessionDelegate.session)
        
        networkManager.fetchOpenWeatherData(latitudeAndLongitude: location,
                                            requestPurpose: .forecast,
                                            sessionDelegate.session)
    }
    
    func locationManager(_ manager: CLLocationManager,
                         didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .locationUnknown:
                break
            default:
                print(error.localizedDescription)
            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if #available(iOS 14.0, *) {
            switch manager.authorizationStatus {
            case .restricted, .denied:
                break
            case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
                manager.requestLocation()
                break
            @unknown default: break
            }
        }
    }
}

