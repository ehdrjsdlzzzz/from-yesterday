//
//  Weather.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 28..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation

class Weather {
    var city: String
    var county: String?
    var village: String?
    var status: String
    var currentTemp: String?
    var todayMaxTemp: String?
    var todayMintemp: String?
    var windSpeed: String?
    
    init(city: String, status: String) {
        self.city = city
        self.status = status
    }
    
}

