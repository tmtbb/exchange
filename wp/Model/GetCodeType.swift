//
//  GetCodeType.swift
//  wp
//
//  Created by sum on 2017/4/5.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class GetCodetype: HttpRequestModel {
    
    //手机号
    var phoneNum : String = ""
    //验证码
    var codeType : Int = 0
    
    
    
}

class RefreshToken: HttpRequestModel {
    
    //刷新token
    var token : String = ""
   
}
