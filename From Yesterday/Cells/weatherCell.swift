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
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dayLabel.text = nil
        descLabel.text = nil
        tempLabel.text = nil
        self.mainView.backgroundColor = UIColor.background
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        dayLabel.text = nil
        descLabel.text = nil
        tempLabel.text = nil
    }
}

// MARK: Property Setting Method

extension weatherCell {
    func setCellValue(weatherIcon:UIImage, day: String, desc: String, tmax:String, tmin: String){
        self.weatherIcon.image = weatherIcon.withRenderingMode(.alwaysTemplate)
        self.weatherIcon.tintColor = UIColor.appTint
        self.dayLabel.text = "\(day)일"
        self.descLabel.text = desc.uppercased()
        self.tempLabel.text = "\(tmax) / \(tmin)"
    }
}
