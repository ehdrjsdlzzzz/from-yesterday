//
//  CurrentWeather.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 30..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation

class CurrentWeather{
    var city: String
    var county: String?
    var village: String?
    var status: String
    var current: String
    var humidity: String
    var min: String
    var max: String
    
    init(city: String, status:String, current:String, humidity: String, min: String, max: String) {
        self.city = city
        self.status = status
        self.current = current
        self.humidity = humidity
        self.min = min
        self.max = max
    }
}
