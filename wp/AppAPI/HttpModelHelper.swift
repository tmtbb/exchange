//
//  HttpModelHelper.swift
//  wp
//
//  Created by J-bb on 17/4/5.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import RealmSwift

class HttpRequestModel: Object {
    
    var requestPath = "requestPath"
    var appVersion = "appVersion"
    var osType = 0
    var sign = "sign"
    var keyId : Int64 = 34474661562457
    var timestamp = 0
    
    
    func toDictionary() -> NSDictionary{

        let properties = objectSchema.properties.map { $0.name }
        let dictionary = dictionaryWithValues(forKeys: properties)
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        if UUID.cheDevivce("deviceKeyId") == false {
            self.keyId = 34474661562457
        }else{
           self.keyId =  Int64.init(UUID.getData("deviceKeyId"))!
        }

        var signString = AppConst.Network.TttpHostUrl + requestPath
        for prop in objectSchema.properties as [Property]! {
            if prop.name == "requestPath" {
                continue
            }
            if let nestedObject = self[prop.name] as? HttpRequestModel {
                mutabledic.setValue(nestedObject.toDictionary(), forKey: prop.name)
            } else {
                if self[prop.name] != nil{
                    signString = signString + "\(prop.name)=\(self[prop.name]!)"
                }
                mutabledic.setValue(self[prop.name], forKey: prop.name)
            }
        }
        mutabledic.setValue(signString.getSignString(), forKey: "sign")
        mutabledic.removeObject(forKey: "requestPath")
        return mutabledic
    }
    
  
    

}

class TokenRequestModel: HttpRequestModel {
    var token = ""
}
