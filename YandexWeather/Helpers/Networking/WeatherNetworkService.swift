//
//  WeatherNetworkService.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 17/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeatherNetworkService {
    
    private init() {}
    
    static let shared = WeatherNetworkService()
    private  let head:[String:String] = ["X-Yandex-API-Key": "9a4dd815-d16d-46a5-bc87-0801a556b444"]
  
    func getWeatherData(url: String, parametrs parameters: [String:String],completion: @escaping(JSON) -> ()) {

            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 20
            manager.request(url, method: .get, parameters: parameters, headers: head).responseJSON { response in
                if response.result.isSuccess {
                    let weatherJSON: JSON = JSON(response.result.value!)
                    DispatchQueue.main.async {
                        completion(weatherJSON)
                    }
                } else {
                    print("Error \(String(describing: response.result.error?.localizedDescription))")
                 
                }
        }
    }
}
    
    
