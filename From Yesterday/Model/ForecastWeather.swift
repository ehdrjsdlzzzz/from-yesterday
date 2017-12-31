//
//  ForecastWeather.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 30..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation

class ForecastWeather {
    var code: Int
    var day:String
    var tc:String
    var tmax:String
    var tmin:String
    var humidity:String
    var status:String
    var country:String?
    var city:String?
    
    init(code:Int, day:String, tc:String, tmax:String, tmin:String, humidity:String, status: String) {
        self.code = code
        self.day = day
        self.tc = tc
        self.tmax = tmax
        self.tmin = tmin
        self.humidity = humidity
        self.status = status
    }
}
