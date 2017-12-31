//
//  URL.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 30..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation
import Alamofire

let BASE = "http://apis.skplanetx.com/weather"
let FORECAST_BASE = "http://api.openweathermap.org/data/2.5/forecast?"
let CURRENT = "/current/hourly?"
let LAT = "&lat="
let LON = "&lon="
let VERSION = "version=1"
let APPKEY = "1fde96e3-0f5e-3f0c-86d2-a949fd339c14"
let OPENWEATHER_APP_ID = "721471522fea6bb16d7a2d152b9eec39"
let LANG = "&lang=kr"


let HTTP_HEADER:HTTPHeaders = [
    "appKey": APPKEY
]

// 8개씩 3,6,9,12,15,18,21,24 //
let CURRENT_WEATHER_URL = BASE + CURRENT + VERSION + LAT + "\(Location.shared.lat)" + LON + "\(Location.shared.lon)"
let FORECAST_WEATHER_URL = FORECAST_BASE + "lat=\(Location.shared.lat)" + "&lon=\(Location.shared.lon)" + "&APPID=\(OPENWEATHER_APP_ID)" + LANG
