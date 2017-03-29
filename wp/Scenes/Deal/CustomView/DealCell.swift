//
//  DealCell.swift
//  wp
//
//  Created by J-bb on 17/3/28.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class DealCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var flightNameLabel: UILabel!
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func setInfo(productModel:ProductModel) {
        priceLabel.text = String.init(format: "%.2f元/公斤", productModel.price)
        flightNameLabel.text = productModel.symbol
    }
    func setIsSelect(isSelect:Bool) {
        if isSelect {
            priceLabel.font = UIFont.systemFont(ofSize: 21)
            backgroundColor = UIColor.white
        } else {
            backgroundColor = UIColor(hexString: "eeeeee")
            priceLabel.font = UIFont.systemFont(ofSize: 14)
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

