//
//  OpenWeatherTableViewDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/15.
//

import UIKit
import CoreLocation.CLLocationManager

final class WeatherTableViewDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: OpenWeatherHeaderView.identifier) as? OpenWeatherHeaderView else {
            return UIView()
        }
        
        guard let weatherData = WeatherDataHolder.shared.current else {
            return UIView()
        }
        
        headerView.configureDateAndTemperature()

        fetchIconImage(weatherData, headerView)
        fetchAddressData(weatherData, headerView)
        headerView.chaneButtonTargets(state: .valid, title: "위치설정")
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
}

extension WeatherTableViewDelegate {
    private func fetchAddressData(_ weatherData: CurrentWeather, _ view: OpenWeatherHeaderView) {
        let currentLocation = CLLocation(latitude: weatherData.coordination.lattitude, longitude: weatherData.coordination.longitude)
        let locale = Locale(identifier: "ko")
        
        CLGeocoder().reverseGeocodeLocation(currentLocation, preferredLocale: locale) { placeMarks, error in
            guard error == nil else {
                return
            }
            
            guard let tableViewController = view.findViewController() as? TableViewController else {
                return
            }
            
            guard let addresses = placeMarks,
                  let city = addresses.last?.locality,
                  let subCity = addresses.last?.subLocality else {
                tableViewController.cleanTableView()
                return
            }
            
            let spacing = " "
            view.confifureAddress(city + spacing + subCity)
        }
    }
    
    private func fetchIconImage(_ weatherData: CurrentWeather, _ view: OpenWeatherHeaderView) {
        let iconID = weatherData.weather.first?.icon
        let date = weatherData.date
        
        let urlString = "https://openweathermap.org/img/w/\(iconID ?? "").png"
        
        ImageLoader.downloadImage(reqeustURL: urlString, imageCachingKey: date) { requestedIcon in
            DispatchQueue.main.async {
                view.configureIconImage(requestedIcon)
            }
        }
    }
}
