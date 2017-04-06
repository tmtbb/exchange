//
//  LoginModel.swift
//  wp
//
//  Created by sum on 2017/4/5.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class LoginModel: HttpRequestModel {

    //手机号
    var phoneNum : String = ""
    //密码
    var password : String = ""
}
class GetDeviceKey: HttpRequestModel {
    
      var deviceId : String = ""
      var deviceModel : String = ""
      var deviceResolution : String = ""
      var deviceName : String = ""
      var osVersion : String = ""
    
    
    
}
