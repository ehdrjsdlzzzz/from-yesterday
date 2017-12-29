//
//  CurrentWeather.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 30..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation

class CurrentWeather{
    var country: String
    var area: String
    var status: String
    var current: Double
    var humidity: Double
    var min: Double
    var max: Double
    
    init(country: String, area: String, status:String, current:Double, humidity: Double, min: Double, max: Double) {
        self.country = country
        self.area = area
        self.status = status
        self.current = current
        self.humidity = humidity
        self.min = min
        self.max = max
    }
}
