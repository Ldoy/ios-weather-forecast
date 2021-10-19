//
//  OpenWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/15.
//

import UIKit
import CoreLocation.CLLocationManager

class OpenWeatherHeaderView: UITableViewHeaderFooterView {
    static let identifier = "weatherHeaderView"
    let buttonvc = ButtonController()
    
    private let addressLabel = UILabel()
    private let minMaxTemperature = UILabel()
    private let currentTemperatureLabel = UILabel()
    private let iconImageView = UIImageView()
    private let locationChangeButton: UIButton = {
        let button = UIButton()
        button.setTitle("위치변경", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.addressLabel, self.minMaxTemperature, self.currentTemperatureLabel])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()

    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [self.iconImageView, self.verticalStackView, self.buttonvc.view])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        return stackView
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clear
        setHorizontalStackView()
        setVerticalStackView()
        setImageIconView()
        convertToDynamicType()
        drawButtonView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func configureDateAndTemperature() {
        guard let currentWeatherData = WeatherDataHolder.shared.current else {
            print("\(#function)에 들어갈 데이터가 없습니다.")
            return
        }
        
        let maxTem = currentWeatherData.main.temperatureMaximum
        let minTem = currentWeatherData.main.temperatureMinimum
        let currentTem = currentWeatherData.main.currentTemperature
        
        let convertedCurentTem = TemperatureConverter(celciusTemperature: currentTem).convertedTemperature
        let convertedmaxTem = TemperatureConverter(celciusTemperature: maxTem).convertedTemperature
        let convertedminTem = TemperatureConverter(celciusTemperature: minTem).convertedTemperature
        
        self.addressLabel.text = "-- ----"
        self.minMaxTemperature.text = "최고 \(convertedmaxTem)° 최저 \(convertedminTem)°"
        self.currentTemperatureLabel.text = "\(convertedCurentTem)°"
    }
    
    func configureIconImage(_ image: UIImage) {
        self.iconImageView.image = image
        self.iconImageView.contentMode = .scaleAspectFit
    }
    
    func confifureAddress(_ address: String) {
        self.addressLabel.text = address
    }
}

extension OpenWeatherHeaderView {
    private func setHorizontalStackView() {
        self.contentView.addSubview(horizontalStackView)
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            horizontalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            horizontalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func setImageIconView() {
        NSLayoutConstraint.activate([
            iconImageView
                .widthAnchor
                .constraint(equalTo: horizontalStackView.widthAnchor,
                            multiplier: 0.2),
            iconImageView
                .heightAnchor
                .constraint(equalTo: horizontalStackView.heightAnchor),
            iconImageView
                .leadingAnchor
                .constraint(equalTo: horizontalStackView.leadingAnchor),
            iconImageView
                .topAnchor
                .constraint(equalTo: horizontalStackView.topAnchor)
        ])
    }
    
    private func setVerticalStackView() {
        NSLayoutConstraint.activate([
            verticalStackView
                .widthAnchor
                .constraint(equalTo: horizontalStackView.widthAnchor,
                            multiplier: 0.8),
            verticalStackView
                .heightAnchor
                .constraint(equalTo: horizontalStackView.heightAnchor, multiplier: 0.8),
            verticalStackView
                .bottomAnchor
                .constraint(equalTo: self.horizontalStackView.bottomAnchor),

            verticalStackView
                .leadingAnchor
                .constraint(equalTo: horizontalStackView.leadingAnchor, constant: 100),
            
            verticalStackView
                .topAnchor
                .constraint(equalTo: horizontalStackView.topAnchor)
        ])
    }
    
    private func convertToDynamicType() {
        setDynamicType(to: self.addressLabel, .body)
        setDynamicType(to: self.minMaxTemperature, .body)
        setDynamicType(to: self.currentTemperatureLabel, .title1)
    }
    
    private func setDynamicType(to label: UILabel, _ font: UIFont.TextStyle) {
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont.preferredFont(forTextStyle: font)
    }
    
    private func drawButtonView() {
        let buttonWidth = (self.contentView.frame.size.width / 5) * 4
        let buttonHeight = buttonWidth / 10
        buttonvc.view.frame = CGRect(x: 320, y: 50,
                                     width: buttonWidth, height: buttonHeight)
    }
}
