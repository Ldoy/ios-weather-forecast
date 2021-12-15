//
//  OpenWeatherHeaderView.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/15.
//

import UIKit
import CoreLocation.CLLocationManager

protocol ButtonDelegate: AnyObject {
    func notifyValidLocationAlert()
    func notifyInvalidLocationAlert()
}

class OpenWeatherHeaderView: UITableViewHeaderFooterView {
    static let identifier = "weatherHeaderView"
    weak var buttonDelegate: ButtonDelegate?
    
    private let button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    @objc private func notifyValidLocationAlert() {
        setButtonDelegate()
        buttonDelegate?.notifyValidLocationAlert()
    }
    
    @objc private func notifyInvalidLocationAlert() {
        setButtonDelegate()
        buttonDelegate?.notifyInvalidLocationAlert()
    }
    
    private func setButtonDelegate() {
        guard let tableView = self.superview as? UITableView else {
            return
        }
        guard let viewController = tableView.findViewController() as? ButtonDelegate else {
            return
        }
        self.buttonDelegate = viewController
    }
    
    private let addressLabel: UILabel = {
        let addressLabel = UILabel()
        return addressLabel
    }()
    
    private let minMaxTemperature = UILabel()
    private let currentTemperatureLabel = UILabel()
    private let iconImageView = UIImageView()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [self.addressLabel,
                               self.minMaxTemperature,
                               self.currentTemperatureLabel]
        )
        
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let stackView = UIStackView(
            arrangedSubviews: [self.iconImageView,
                               self.verticalStackView,
                               self.button]
        )
        
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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum LocationState {
        case valid
        case invalid
    }
    
    func chaneButtonTargets(state: LocationState, title: String) {
        self.button.setTitle(title, for: .normal)
        self.button.removeTarget(nil,
                                 action: nil,
                                 for: .allEvents)
        switch state {
        case .valid:
            self.button.addTarget(nil,
                                  action: #selector(notifyValidLocationAlert),
                                  for: .touchUpInside)
        case .invalid:
            self.button.addTarget(nil,
                                  action: #selector(notifyInvalidLocationAlert),
                                  for: .touchUpInside)
            
        }
    }
    
    func configureDateAndTemperature() {
        guard let currentWeatherData = WeatherDataHolder.shared.current else {
            print("\(#function)에 들어갈 데이터가 없습니다.")
            return
        }
        
        let maxTemperature = currentWeatherData.main.temperatureMaximum
        let minTemperature = currentWeatherData.main.temperatureMinimum
        let currentTemperature = currentWeatherData.main.currentTemperature
        
        let convertedCurentTemperature = TemperatureConverter(celciusTemperature: currentTemperature).convertedTemperature
        let convertedMaxTemperature = TemperatureConverter(celciusTemperature: maxTemperature).convertedTemperature
        let convertedMinTemperature = TemperatureConverter(celciusTemperature: minTemperature).convertedTemperature
        
        self.minMaxTemperature.text = "최고 \(convertedMaxTemperature)° 최저 \(convertedMinTemperature)°"
        self.currentTemperatureLabel.text = "\(convertedCurentTemperature)°"
    }
    
    func configureIconImage(_ image: UIImage) {
        self.iconImageView.image = image
        self.iconImageView.contentMode = .scaleAspectFit
    }
    
    func confifureAddress(_ address: String) {
        self.addressLabel.text = address
    }
    
    func showRequestFailableCell() {
        self.addressLabel.text = "위치정보가 없어요🥲"
    }
}

extension OpenWeatherHeaderView {
    private func setHorizontalStackView() {
        self.contentView.addSubview(horizontalStackView)
        horizontalStackView.setPosition(top: self.contentView.topAnchor,
                                        bottom: self.contentView.bottomAnchor,
                                        leading: self.contentView.leadingAnchor,
                                        trailing: self.contentView.trailingAnchor)
    }
    
    private func setImageIconView() {
        NSLayoutConstraint.activate([
            iconImageView
                .widthAnchor
                .constraint(equalTo: self.contentView.widthAnchor,
                            multiplier: 0.25),
            iconImageView.widthAnchor.constraint(equalTo: iconImageView.heightAnchor, multiplier: 1)
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
        label.textColor = .white
        label.font = UIFont.preferredFont(forTextStyle: font)
    }
    
    override func prepareForReuse() {
        self.addressLabel.text = "--"
        self.minMaxTemperature.text = "--"
        self.currentTemperatureLabel.text = "--"
        self.iconImageView.image = nil
    }
}
