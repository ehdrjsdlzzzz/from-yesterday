//
//  Location.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 30..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation

class Location {
    static var shared = Location()
    private init(){}
    
    
    // default : Seoul
    var lat:Double = 37.566870
    var lon:Double = 126.977974
    
}
