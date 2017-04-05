
//
//  UserInfoModel.swift
//  wp
//
//  Created by sum on 2017/4/5.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class UserInfoVCModel: NSObject {
    
    
    private static var model: UserInfoVCModel = UserInfoVCModel()
    class func share() -> UserInfoVCModel{
        return model
    }
}
class CompanyInfoVCModel: NSObject {
    
    private static var model: CompanyInfoVCModel = CompanyInfoVCModel()
    class func share() -> CompanyInfoVCModel{
        return model
    }
    
}
