//
//  MapPresenter.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 17/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import Foundation
import SwiftyJSON

class MapPresenter {
    
    private let WEATHER_URL = "https://api.weather.yandex.ru/v1/forecast"
    static let shared = MapPresenter()
   
    func getWeatherDataPresenter(parameters: [String : String], completion: @escaping(WeatherDataRealm) -> ()) {
        
        WeatherNetworkService.shared.getWeatherData(url: WEATHER_URL, parametrs: parameters) { (weatherJSON) in
            WeatherDataServise.shared.updateWeatherData(json: weatherJSON, completion: { (weatherDataRealm) in
                completion(weatherDataRealm)
            })
           
        }
    }
    
   
}
