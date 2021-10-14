//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import CoreLocation

final class OpenWeatherMainViewController: UIViewController {
    private let locationManager = LocationManager()
    private var location = (longitude: CLLocationDegrees() , latitude: CLLocationDegrees())
        
    private let tableViewDataSource = WeatherTableviewDataSource()
    private let tableView = UITableView()
    private lazy var address: String = {
        let location = CLLocation(latitude: self.location.latitude, longitude: self.location.longitude)
        let geoCoder = CLGeocoder()
        let locale = Locale(identifier: "Ko-kr")
        geoCoder.reverseGeocodeLocation(location, preferredLocale: locale) { placeMarks, error in
            guard error == nil else {
                return
            }
            
            guard let addresses = placeMarks,
                  let address = addresses.last?.name else {
                return
            }
        }
        return address
    }()
    
    //MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        drawTableView()
        locationManager.delegate = self
        locationManager.askUserLocation()
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView), name: .reloadTableView, object: nil)
    }
    
    @objc func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else {
                return
            }
            self.tableView.dataSource = self.tableViewDataSource
            self.tableView.reloadData()
        }
    }
}

extension OpenWeatherMainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latitude = locations.last?.coordinate.latitude,
              let longitude = locations.last?.coordinate.longitude else {
            return
        }
        
        let sessionDelegate = OpenWeatherSessionDelegate()
        let networkManager = WeatherNetworkManager()
        
        guard let api = networkManager.buildApi(weatherOrCurrent: .forecast, location: (latitude, longitude)) else {
            return
        }
        // 위치정보 넣으면 바로 만들 수 있도록 ???
        
        networkManager.fetchOpenWeatherData(requiredApi: api, sessionDelegate.session)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if let error = error as? CLError {
            switch error.code {
            case .locationUnknown:
                break
            default:
                print(error.localizedDescription)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .denied:
            showAlert(title: "🥲", message: "날씨 정보를 사용 할 수 없습니다.")
            break
        case .authorizedWhenInUse, .authorizedAlways, .notDetermined:
            manager.requestLocation()
            break
        @unknown default:
            showAlert(title: "🥳", message: "애플이 새로운 정보를 추가했군요! 확인 해 봅시다😄")
        }
    }
}

extension OpenWeatherMainViewController {
    private func drawTableView() {
        self.view.addSubview(tableView)
        self.tableView.frame = self.view.bounds
        self.tableView.register(FiveDaysForcecastCell.self, forCellReuseIdentifier: "weatherCell")
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
        let iconSize = 40
        self.tableView.rowHeight = CGFloat(iconSize)
    }
    
    private func showAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
