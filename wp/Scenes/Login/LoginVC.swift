//
//  LoginVC.swift
//  wp
//
//  Created by 木柳 on 2016/12/17.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
import DKNightVersion
class LoginVC: BaseTableViewController {
    
    @IBOutlet weak var qqBtn: UIButton!
    @IBOutlet weak var wechatBtn: UIButton!
    @IBOutlet weak var sinaBtn: UIButton!
    
    @IBOutlet weak var pwdView: UIView!
    @IBOutlet weak var phoneView: UIView!
    @IBOutlet weak var phoneText: UITextField!
    @IBOutlet weak var pwdText: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initData()
        initUI()
      
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: Notification.Name(rawValue:AppConst.NotifyDefine.UpdateUserInfo), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: --DATA
    func initData() {
        NotificationCenter.default.addObserver(self, selector: #selector(errorCode(_:)), name: NSNotification.Name(rawValue: AppConst.WechatKey.ErrorCode), object: nil)
    }
    //MARK: --UI
    func initUI() {
        phoneView.layer.borderWidth = 0.5
        phoneView.layer.borderColor = UIColor.init(rgbHex: 0xcccccc).cgColor
        pwdView.layer.borderWidth = 0.5
        pwdView.layer.borderColor = UIColor.init(rgbHex: 0xcccccc).cgColor
        
        loginBtn.dk_backgroundColorPicker = DKColorTable.shared().picker(withKey: AppConst.Color.main)
        qqBtn.dk_backgroundColorPicker = DKColorTable.shared().picker(withKey: AppConst.Color.main)
        wechatBtn.dk_backgroundColorPicker = DKColorTable.shared().picker(withKey: AppConst.Color.main)
        sinaBtn.dk_backgroundColorPicker = DKColorTable.shared().picker(withKey: AppConst.Color.main)
        
    }
    //MARK: --手机号登录
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        
        if checkTextFieldEmpty([phoneText,pwdText]){
            if isTelNumber(num: phoneText.text!) == false{
                SVProgressHUD.showErrorMessage(ErrorMessage: "手机号格式错误", ForDuration: 1, completion: nil)
                return
            }
            //登录

        
            SVProgressHUD.showProgressMessage(ProgressMessage: "登录中...")
            
                    let model : LoginModel = LoginModel()
                    model.phoneNum = phoneText.text!
                    model.password = pwdText.text!
                    model.requestPath = "/api/user/login.json"
            
            HttpRequestManage.shared().postRequestModelWithJson(requestModel: model, reseponse: { (result) in
                SVProgressHUD.dismiss()
                let datadic = result as? Dictionary<String,AnyObject>

                if let _ =  datadic?["token"]{
                     UserDefaults.standard.setValue(datadic?["token"] as! String, forKey: SocketConst.Key.token)
                    SVProgressHUD.showSuccess(withStatus: "登录成功")
                    UserInfoVCModel.share().upateUserInfo(userObject: result)

                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.UpdateUserInfo), object: nil)
                    self.loginSuccess()
                }
            }, failure: { (error) in
                
            })

        }
//            AppAPIHelper.login().login(phone: phoneText.text!, password: password, complete: { [weak self]( result) -> ()? in
//                SVProgressHUD.dismiss()
//                DealModel.share().isFirstGetPrice = true
//                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.RequestPrice), object: nil)
//                //存储用户信息
//                if result != nil{
//                    UserDefaults.standard.set(self?.phoneText.text!, forKey: SocketConst.Key.phone)
        
//                }else{
//                    SVProgressHUD.showErrorMessage(ErrorMessage: "登录失败，请稍后再试", ForDuration: 1, completion: nil)
//                }
//                return nil
//                }, error: errorBlockFunc())
//        }
        
    }
    
    func loginSuccess() {
        dismissController()
    }
    
    //MARK: --微信登录
    @IBAction func wechatBtnTapped(_ sender: UIButton) {
        let req = SendAuthReq.init()
        req.scope = AppConst.WechatKey.Scope
        req.state = AppConst.WechatKey.State
        WXApi.send(req)
    }
    func errorCode(_ notice: NSNotification) {
        
        if let errorCode: Int = notice.object as? Int{
            if errorCode == -4{
                
                return
            }
            if errorCode == -2{
                
                return
            }
            //第三方登录成功
            performSegue(withIdentifier: AppConst.NotifyDefine.LoginToBingPhoneVC, sender: nil)
        }
        
    }
    
    //MARK: --忘记密码
    @IBAction func forgetPwdBtnTapped(_ sender: UIButton) {
        UserModel.share().forgetPwd = true
    }
    //MARK: --快速注册
    @IBAction func registerBtnTapped(_ sender: UIButton) {
        UserModel.share().forgetPwd = false
        UserModel.share().forgetType = .loginPass
    }
    
    @IBAction func EnterPriseVC(_ sender: UIButton) {

        self.performSegue(withIdentifier: "EnterPriseVC", sender: nil)
    }
    //MARK: --新浪登录
    @IBAction func sinaBtnTapped(_ sender: UIButton) {
        
    }
    //取消登录
    @IBAction func cancelBtnTapped(_ sender: Any) {
        dismissController()
    }
}
