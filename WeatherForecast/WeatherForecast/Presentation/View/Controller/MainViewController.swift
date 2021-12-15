//
//  WeatherForecast - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {

    private let tableViewController = TableViewController()
    private let locationViewController = LocationViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViewControllers()
        self.view.addBackground(imageName: "OpenWeatherBackground")
    }
    
    private func addViewControllers() {
        add(tableViewController)
        add(locationViewController)
        self.view.addSubview(tableViewController.view)
        tableViewController.view.frame = self.view.bounds
    }
    
    func getLocation() -> Location? {
        self.locationViewController.getLocation()
    }
}
