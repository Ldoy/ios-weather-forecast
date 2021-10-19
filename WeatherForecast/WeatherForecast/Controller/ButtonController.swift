//
//  ButtonController.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/19.
//

import UIKit
import CoreLocation.CLLocation

class ButtonController: UIViewController {
    private var button: UIButton = {
        let button = UIButton()
        button.setTitle("위치설정", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self,
                         action: #selector(showLocationChangeAlert),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawButton()
    }
    
    private lazy var invalidLocationAlert: UIAlertController = {
        let alert = UIAlertController(title: "위치변경",
                                      message: "날씨를 받아올 위치의 위도와 경도를 입력해주세요",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        alert.addAction(UIAlertAction(title: "변경", style: .default))
        
        alert.addTextField { field in
            field.placeholder = "위도"
        }
        alert.addTextField { field in
            field.placeholder = "경도"
        }
        return alert
    }()
    
   private func isValidLocation(_ location: Location) -> Bool {
    let lat = Double(location.latitude)
    let long = Double(location.longitude)
    if lat > 90.0, lat < -90,
           long > 180, long < -180 {
            return true
        }
        return false
    }
    
    private lazy var userLocationAcceptAlert: UIAlertController = {
        let alert = UIAlertController(title: "위치변경",
                                      message: "변경할 좌표를 선택해주세요",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "변경", style: .default) {_ in
            if let latText = alert.textFields?[0].text,
               let longText = alert.textFields?[1].text,
               let lat = Double(latText),
               let long = Double(longText),
               self.isValidLocation(Location(lat,long)) {
                
                let location: Location = (lat, long)
                let sessionDelegate = OpenWeatherSessionDelegate()
                let networkManager = WeatherNetworkManager()
                
                networkManager.fetchOpenWeatherData(latitudeAndLongitude: location,
                                                    requestPurpose: .currentWeather,
                                                    sessionDelegate.session)
                
                networkManager.fetchOpenWeatherData(latitudeAndLongitude: location,
                                                    requestPurpose: .forecast,
                                                    sessionDelegate.session)
            } else {
                self.dismiss(animated: true) {
                    self.button.setTitle(LocationDataState.disFetchable.buttonTitle,
                                         for: .normal)
                    
                }
            }
        })
        return alert
    }()
}

extension ButtonController {
    private func drawButton() {
        self.view.addSubview(button)
        self.button.setPosition(top: self.view.topAnchor,
                                bottom: self.view.bottomAnchor,
                                leading: self.view.leadingAnchor,
                                trailing: self.view.trailingAnchor)
    }
    
    @objc func showLocationChangeAlert() {
        self.present(userLocationAcceptAlert, animated: true)
    }
}
