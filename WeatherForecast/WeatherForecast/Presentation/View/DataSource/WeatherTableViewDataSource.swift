//
//  WeatherTableViewDataSource.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/11.
//

import UIKit.UITableView

final class WeatherTableviewDataSource: NSObject, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeatherDataHolder.shared.forcast?.list.count ?? .zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FiveDaysForecastCell.identifier, for: indexPath) as? FiveDaysForecastCell else {
            return UITableViewCell()
        }
        
        guard let list = WeatherDataHolder.shared.forcast?.list[indexPath.row] else {
            return UITableViewCell()
        }

        let urlString = "https://openweathermap.org/img/w/\(list.weather.first?.icon ?? "").png"
      
        ImageLoader.downloadImage(reqeustURL: urlString, imageCachingKey: list.date) { requestedIcon in
            DispatchQueue.main.async {
                cell.configure(requestedIcon)
            }
        }
//        
//        let cellHolder = CellHolder(forcastInformation: WeatherDataHolder.shared.forcast?)
//        
//        cell.configure(cellHolder)

        return cell
    }    
}
