//
//  ForecastWeather.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 30..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation

class ForecastWeather {
    var day:String
    var tc:Double
    var tmax:Double
    var tmin:Double
    var humidity:Double
    var status:String
    
    init(day:String, tc:Double, tmax:Double, tmin:Double, humidity:Double, status: String) {
        self.day = day
        self.tc = tc
        self.tmax = tmax
        self.tmin = tmin
        self.humidity = humidity
        self.status = status
    }
}
