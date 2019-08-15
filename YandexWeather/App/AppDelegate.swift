//
//  AppDelegate.swift
//  YandexWeather
//
//  Created by Sergey Koriukin on 09/08/2019.
//  Copyright © 2019 Sergey Koriukin. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey("AIzaSyA-1-5FDuGoOVsPbM26C-lD86MPG6-U8ME")
        return true
    }


}

