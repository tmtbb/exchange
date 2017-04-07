//
//  RegistModel.swift
//  wp
//
//  Created by sum on 2017/4/5.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class RegistModel: HttpRequestModel {

    //手机号
    var phoneNum : String = ""
    //密码
    var password : String = ""
    //验证码
    var phoneCode : String = ""
    //验证码token
    var codeToken : String = ""
    //真实姓名
    var fullName : String = ""
    //身份证号
    var identityCard : String = ""
    
}
class RegistCompanyModel: HttpRequestModel {
    
    //手机号
    var phoneNum : String = ""
    //密码
    var password : String = ""
    //验证码
    var phoneCode : String = ""
    //验证码token
    var codeToken : String = ""
    //真实姓名
    var fullName : String = ""
    //身份证号
    var identityCard : String = ""
    //身份证号
    var address : String = ""
    //身份证号
    var email : String = ""
    //身份证号
    var businessLicense : String = ""
    //身份证号
    var identityCardJust : String = ""
    //身份证号
    var identityCardBack : String = ""
    
}

