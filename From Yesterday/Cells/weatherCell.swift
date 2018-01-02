//
//  weatherCell.swift
//  From Yesterday
//
//  Created by 이동건 on 2018. 1. 1..
//  Copyright © 2018년 이동건. All rights reserved.
//

import UIKit
import ScalingCarousel

class weatherCell: ScalingCarouselCell {
    
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var tmaxLabel: UILabel!
    @IBOutlet weak var tminLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.text = nil
        tmaxLabel.text = nil
        tminLabel.text = nil
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        dayLabel.text = nil
        tmaxLabel.text = nil
        tminLabel.text = nil
    }
}

// MARK: Property Setting Method

extension weatherCell {
    func setCellValue(weatherIcon:UIImage, day: String, tmax:String, tmin: String){
        self.weatherIcon.image = weatherIcon
        self.dayLabel.text = "\(day)일"
        self.tmaxLabel.text = tmax
        self.tminLabel.text = tmin
    }
}
