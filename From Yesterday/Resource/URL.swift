//
//  URL.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 30..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation
import Alamofire

let BASE = "http://apis.skplanetx.com/gweather"
let CURRENT = "/forecast/mid?"
let LAT = "&lat="
let LON = "&lon="
let VERSION = "version=1"
let TIMEZONE = "&timezone="
let LOCAL = "local"
let APPKEY = "1fde96e3-0f5e-3f0c-86d2-a949fd339c14"
let HTTP_HEADER:HTTPHeaders = [
    "appKey": APPKEY
]

// 8개씩 3,6,9,12,15,18,21,24 //
let CURRENT_WEATHER_URL = BASE + CURRENT + VERSION + LAT + "\(Location.shared.lat)" + LON + "\(Location.shared.lon)" + TIMEZONE + LOCAL

