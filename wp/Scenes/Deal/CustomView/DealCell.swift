//
//  DealCell.swift
//  wp
//
//  Created by J-bb on 17/3/28.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class DealCell: UITableViewCell {

    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var flightNameLabel: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization cod
        
    }
    
    
    func setInfo(flightModel:FlightModel) {
        priceLabel.text = String.init(format: "%.2f元/公斤", flightModel.flightSpacePrice)
        flightNameLabel.text = flightModel.flightNumber
        countLabel.text = "\(flightModel.flightSpaceNumber)"
    }
    func setIsSelect(isSelect:Bool) {
        if isSelect {
            priceLabel.font = UIFont.systemFont(ofSize: 21)
            backgroundColor = UIColor.white
            bottomViewHeight.constant = 1.555555
        } else {
            backgroundColor = UIColor(hexString: "fafafa")
            priceLabel.font = UIFont.systemFont(ofSize: 14)
            bottomViewHeight.constant = 1.0
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

