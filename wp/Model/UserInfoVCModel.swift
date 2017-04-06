
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
    
    private static var model: UserInfoVCModel = UserInfoVCModel()
    class func share() -> UserInfoVCModel{
        return model
    }
 
        var status : Int = 0
        var userType : Int = 0
        var phoneNum : String = ""
        var name : String = ""
        var balance : Double = 0
        var userId : Int64 = 0
        var identityCard : String = ""
//        var currentUser: UserInfoVCModel?
    // UserDefaults.standard.setValue( UserInfoVCModel.share().currentUserId, forKey: SocketConst.Key.uid)
       var currentUserId: Int64 = UserDefaults.standard.object(forKey: SocketConst.Key.uid) == nil ? 0 : ( UserDefaults.standard.object(forKey: SocketConst.Key.uid) as! Int64)
    

    override static func primaryKey() -> String?{
        return "userId"
    }
    class func userInfo(userId: Int) -> UserInfoVCModel? {
//        if userId == 0 {
//            return nil
//        }
        
        let realm = try! Realm()
        let filterStr = "userId = \(userId)"
        let user = realm.objects(UserInfoVCModel.self).filter(filterStr).first
        if user != nil{
            return user!
        }else{
            return nil
        }
    }
    func getCurrentUser() -> UserInfoVCModel? {
        let user = UserInfoVCModel.userInfo(userId:Int(currentUserId))
        if user != nil {
            return user
        }else{
            return nil
        }
    }
    // 更新用户信息
    func upateUserInfo(userObject: AnyObject){
        
        
        let info = GetUserInfo()
        info.requestPath = "/api/user/info.json"
        info.token = UserDefaults.standard.object(forKey: SocketConst.Key.token) as! String
        HttpRequestManage.shared().postRequestModel(requestModel: info, responseClass: UserInfoVCModel.self, reseponse: { (result) in
            
            
            if let model = result as? UserInfoVCModel {
//                            token = model.token!
                            //存储token
//                            UserDefaults.standard.setValue(token, forKey: SocketConst.Key.token)
                UserInfoVCModel.share().currentUserId = result.userId
                UserDefaults.standard.setValue( UserInfoVCModel.share().currentUserId, forKey: SocketConst.Key.uid)
                
//                 UserInfoVCModel.share().updateRealm()
                //存储uid
//                if let phone = model.phoneNum {
//                    UserDefaults.standard.setValue(phone, forKey: SocketConst.Key.phone)
//                }
                UserDefaults.standard.setValue( UserInfoVCModel.share().currentUserId, forKey: SocketConst.Key.uid)
                let realm = try! Realm()
                try! realm.write {
//                     UserInfoVCModel.share().currentUser  =  model
                    realm.add(model, update: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.UpdateUserInfo), object: nil)
                    
                }
            }
            
//            UserInfoVCModel.share().Model = result as? UserInfoVCModel
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.UpdateUserInfo), object: nil)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.UpdateUserInfo), object: nil)
            
        }) { (error) in
            
        }
    }
    //更新realm
    func updateRealm(){
        let buildNumber = Bundle.main.infoDictionary?[AppConst.BundleInfo.CFBundleVersion.rawValue]
        var config = Realm.Configuration()
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("\(UserInfoVCModel.share().currentUserId).realm")
        config.schemaVersion = UInt64(buildNumber as! String)!
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < UInt64(buildNumber as! String)!{
                
            }
        }
        Realm.Configuration.defaultConfiguration = config
        _ = try! Realm()
        YD_CountDownHelper.shared.resetDataSource()
    }
}
class CompanyInfoVCModel: NSObject {
    
    private static var model: CompanyInfoVCModel = CompanyInfoVCModel()
    class func share() -> CompanyInfoVCModel{
        return model
    }
    
}
