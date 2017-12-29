//
//  URL.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 30..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation

let BASE = "http://api.openweathermap.org/data/2.5/"
let CURRENT = "/weather?"
let FORECAST = "/forecast/daily?"
let LAT = "lat="
let LON = "&lon="
let APPID = "&appid="
let KEY = "721471522fea6bb16d7a2d152b9eec39"

let CURRENT_WEATHER_URL = BASE + CURRENT + LAT + "\(Location.shared.lat)" + LON + "\(Location.shared.lon)" + APPID + KEY
