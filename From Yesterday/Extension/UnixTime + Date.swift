//
//  UnixTime + Date.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 31..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation

func unixToDay(_ unixTime:Double)->String {
    let unixTimeToReal = Date(timeIntervalSince1970: unixTime) // "Dec 31, 2017 at 9:00 PM"
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd"
    return dateFormatter.string(from: unixTimeToReal) // "31"
}
