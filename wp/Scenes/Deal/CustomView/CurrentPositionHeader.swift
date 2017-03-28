//
//  CurrentPositionHeader.swift
//  wp
//
//  Created by J-bb on 17/3/27.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import SnapKit

class CurrentPositionHeader: UITableViewHeaderFooterView {

    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let label = UILabel()
        label.text = "当前持有仓位"
        label.font = UIFont.systemFont(ofSize: 25)
        label.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
