//
//  Rounding + Double.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 30..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation
//import UIKit

extension Double {
    static func rounded(_ value: Double)->Double{
        return Darwin.round(value*100)/100
    }
}
