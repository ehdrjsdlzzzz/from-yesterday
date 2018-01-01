//
//  Unicode + String.swift
//  From Yesterday
//
//  Created by 이동건 on 2018. 1. 1..
//  Copyright © 2018년 이동건. All rights reserved.
//

import Foundation

extension String {
    var degree: String {
        return "\(self)\u{00B0}C"
    }
}
