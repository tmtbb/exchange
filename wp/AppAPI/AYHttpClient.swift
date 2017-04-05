//
//  AYHttpClient.swift
//  OMHSC
//
//  Created by alimysoyang on 16/6/2.
//  Copyright © 2016年 alimysoyang. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

/**
 * URL头
 */
private let urlString = "http://120.26.102.133:80/app/";

/**
 *  回调
 */
typealias reseponseBlock = (_ reseponseObject:AnyObject)->Void

class AYHttpClient: NSObject {

     /**
      post请求
      - parameter path:
      - parameter parameters:
      - parameter reseponse:
      */
     class func postRequest(_ path:String, parameters:Dictionary<String, Any>, reseponse:@escaping reseponseBlock){
          
          let urlPath = urlString + path;
        
          Alamofire.request(urlPath, method: .post, parameters: parameters).responseJSON { (responseData) in
            if responseData.result.error == nil {
                reseponse(responseData.result.value! as AnyObject)
            } else {
                SVProgressHUD.showErrorMessage(ErrorMessage: "错误码：\(responseData.result.error!._code)", ForDuration: 1.5, completion: nil)
            }
        }
        
    }
     
     /**
      get请求
      
      - parameter path:
      - parameter reseponse:
      */
    class func getRequest(_ path:String, reseponse:@escaping reseponseBlock){
        
        let urlPath = urlString + path;
        Alamofire.request(urlPath).responseJSON { (responseData) in
            if responseData.result.error == nil {
                
                reseponse(responseData.result.value! as AnyObject)
            } else {
                SVProgressHUD.showErrorMessage(ErrorMessage: "错误码：\(responseData.result.error!._code)", ForDuration: 1.5, completion: nil)
            }
            
        }
    }
    
    
}
