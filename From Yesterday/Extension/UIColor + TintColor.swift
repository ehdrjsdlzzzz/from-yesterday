//
//  UIColor + TintColor.swift
//  From Yesterday
//
//  Created by 이동건 on 2018. 1. 3..
//  Copyright © 2018년 이동건. All rights reserved.
//

import UIKit
import Foundation

extension UIColor {
    static var appTint: UIColor{
        return UIColor(red: 0.0 ,green: 76.0/255.0, blue: 89.0/255.0, alpha: 1.0) // posting
    }
    
    static var backgroundTint: UIColor {
        return UIColor(red: 255.0/255.0, green: 234.0/255.0, blue: 201.0/255.0, alpha: 1.0)
    }
    
    static var borderTint:UIColor {
        return UIColor(red: 68.0/255.0, green: 76.0/255.0, blue: 75.0/255.0, alpha: 1.0)
    }
}
