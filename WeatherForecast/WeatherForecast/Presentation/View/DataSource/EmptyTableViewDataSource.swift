//
//  EmptyDataSource.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/20.
//

import UIKit.UITableView

final class EmptyDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiveDaysForecastCell.identifier, for: indexPath) as? FiveDaysForecastCell else {
            return UITableViewCell()
        }
        
        return cell
    }
}
