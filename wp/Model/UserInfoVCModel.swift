
//
//  UserInfoModel.swift
//  wp
//
//  Created by sum on 2017/4/5.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import RealmSwift
class UserInfoVCModel: Object {
    
    
    var Model : UserInfoVCModel?
    var status : Int = 0
    var userType : Int = 0
    var phoneNum : String = ""
    var name : String = ""
    var balance : Double = 0
    var userId : Int64 = 0
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
