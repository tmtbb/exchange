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
    
    var requestPath = ""
    var appVersion = ""
    var osType = 0
    var sign = ""
    var keyId = 0
    var timestamp = 0
    
}

extension Object {
    func ModelToDictionary() -> NSDictionary {
        let properties = objectSchema.properties.map { $0.name }
        let dictionary = dictionaryWithValues(forKeys: properties)
        let mutabledic = NSMutableDictionary()
        mutabledic.setValuesForKeys(dictionary)
        for prop in objectSchema.properties as [Property]! {
            if let nestedObject = self[prop.name] as? Object {
                mutabledic.setValue(nestedObject.ModelToDictionary(), forKey: prop.name)
            } else if let nestedListObject = self[prop.name] as? ListBase {
                var objects = [AnyObject]()
                for index in 0..<nestedListObject._rlmArray.count  {
                    let object = nestedListObject._rlmArray[index] as AnyObject
                    objects.append(object.ModelToDictionary())
                }
                mutabledic.setObject(objects, forKey: prop.name as NSCopying)
            }
            
        }
        mutabledic.removeObject(forKey: "requestPath")
        return mutabledic
    }

}
