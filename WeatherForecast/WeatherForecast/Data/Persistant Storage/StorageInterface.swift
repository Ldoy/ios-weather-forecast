//
//  Storage.swift
//  WeatherForecast
//
//  Created by Do Yi Lee on 2021/12/17.
//

import Foundation

protocol Storage: AnyObject {
    // 디코딩한 데이터 저장하기
   // var gasStationDecodedData: GasStationModel? { get }
    //func save(_ result: GasStationModel)
    associatedtype Entity
    var data: Entity? { get }
    func save(from parsedData: Entity)
}
