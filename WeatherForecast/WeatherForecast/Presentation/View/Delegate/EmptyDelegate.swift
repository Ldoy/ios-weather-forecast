//
//  EmptyDelegate.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/10/20.
//

import UIKit.UITableView

final class EmptyDelegate: NSObject, UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: OpenWeatherHeaderView.identifier) as? OpenWeatherHeaderView else {
            return UIView()
        }
        
        view.chaneButtonTargets(state: .invalid, title: "위치변경")
        view.showRequestFailableCell()
        return view
    }
}
