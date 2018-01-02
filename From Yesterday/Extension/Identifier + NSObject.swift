//
//  Identifier + String.swift
//  From Yesterday
//
//  Created by 이동건 on 2018. 1. 1..
//  Copyright © 2018년 이동건. All rights reserved.
//

import Foundation

extension NSObject {
    static var reuseableIdentifier: String {
        return String(describing : self)
    }
}
