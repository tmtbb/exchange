//
//  ProductTypeView.swift
//  wp
//
//  Created by macbook air on 17/1/12.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import DKNightVersion

class ProdectCell: UITableViewCell {
    
    //产品名字
    @IBOutlet weak var productName: UILabel!
    //现价
    @IBOutlet weak var nowPrice: UILabel!
  
    //设置阴影
    @IBOutlet weak var viewShadow: UIView!
  
    
    var kChartModel: KChartModel? {
        didSet{
            if kChartModel == nil {
                return
            }
            productName.text = String.init(format: "%@", kChartModel!.name)
            nowPrice.text = String.init(format: "%.4f", kChartModel!.currentPrice)
          
           
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewShadow.layer.shadowColor = UIColor.black.cgColor
        viewShadow.layer.shadowRadius = 3
        viewShadow.layer.shadowOpacity = 0.3
        viewShadow.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
       nowPrice.adjustsFontSizeToFitWidth = true
       
        
    }
}

