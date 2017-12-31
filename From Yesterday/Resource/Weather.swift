//
//  Weather.swift
//  From Yesterday
//
//  Created by 이동건 on 2017. 12. 31..
//  Copyright © 2017년 이동건. All rights reserved.
//

import Foundation

enum Weather:Int{
    case C600 = 600
    case C601 = 601
    case C602 = 602
    case C611 = 611
    case C612 = 612
    case C615 = 615
    case C616 = 616
    case C620 = 620
    case C621 = 621
    case C622 = 622
    case C200 = 200
    case C201 = 201
    case C202 = 202
    case C210 = 210
    case C211 = 211
    case C212 = 212
    case C221 = 221
    case C230 = 230
    case C231 = 231
    case C232 = 232
    case C300 = 300
    case C301 = 301
    case C302 = 302
    case C310 = 310
    case C311 = 311
    case C312 = 312
    case C313 = 313
    case C314 = 314
    case C321 = 321
    case C500 = 500
    case C501 = 501
    case C502 = 502
    case C503 = 503
    case C504 = 504
    case C511 = 511
    case C520 = 520
    case C521 = 521
    case C522 = 522
    case C531 = 531
    case C701 = 701
    case C711 = 711
    case C721 = 721
    case C731 = 731
    case C741 = 741
    case C751 = 751
    case C761 = 761
    case C762 = 762
    case C771 = 771
    case C781 = 781
    case C800 = 800
    case C801 = 801
    case C802 = 802
    case C803 = 803
    case C804 = 804
    case C900 = 900
    case C901 = 901
    case C902 = 902
    case C903 = 903
    case C904 = 904
    case C905 = 905
    case C906 = 906
    case C950 = 950
    case C951 = 951
    case C952 = 952
    case C953 = 953
    case C954 = 954
    case C955 = 955
    case C956 = 956
    case C957 = 957
    case C958 = 958
    case C959 = 959
    case C960 = 960
    case C961 = 961
    case C962 = 962
    
    func image()->String {
        switch self {
        case .C200, .C201, .C202, .C901, .C960, .C961, .C771:
            return "storm.png"
        case .C210, .C211, .C212, .C221:
            return "storm-1.png"
        case .C230, .C231, .C232 :
            return "rain-1.png"
        case .C300, .C301, .C302:
            return "rain-4.png"
        case .C310, .C311, .C312, .C313, .C314, .C321:
            return "rain.png"
        case .C500, .C501:
            return "rain-6.png"
        case .C502, .C503, .C504, .C511:
            return "rain-7.png"
        case .C520, .C521, .C522, .C531:
            return "rain-2.png"
        case .C600, .C601, .C602, .C611, .C612, .C615, .C616 :
            return "snowing-1.png"
        case .C620, .C621, .C622 :
            return "snowing-2.png"
        case .C701, .C721, .C741, .C711:
            return "mist.png"
        case .C781, .C900:
            return "tornado.png"
        case .C800, .C951, .C950:
            return "sun.png"
        case .C801, .C802, .C803, .C804:
            return "clound-1.png"
        case .C902, .C962:
            return "tornado.png"
        case .C903:
            return "thermometer-3.png"
        case .C904:
            return "thermometer-4.png"
        case .C905:
            return "windy-1.png"
        case .C906:
            return "snowing.png"
        case .C952, .C953, .C954, .C955, .C956, .C957, .C958, .C959:
            return "windy.png"
        case .C731, .C751, .C761, .C762:
            return "warning.png"
        }
    }
}



