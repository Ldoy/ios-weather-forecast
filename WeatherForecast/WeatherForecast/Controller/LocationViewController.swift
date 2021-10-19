//
//  LocationViewController.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit

class LocationViewController: UIViewController {
    private let locationManager = LocationManager()
    private let locationManagerDelegate = LocationManagerDelegate()

    //MARK: - View's Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = locationManagerDelegate
        locationManager.askUserLocation()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(requestLocationAgain),
                                               name: .requestLocationAgain,
                                               object: nil)
    }
    
    @objc func requestLocationAgain() {
        self.locationManager.requestLocation()
    }
}
