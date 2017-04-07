//
//  UserTableViewController.swift
//  wp
//
//  Created by macbook air on 16/12/22.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SideMenuController
import DKNightVersion
class UserTableViewController: BaseTableViewController {
    //头像
    @IBOutlet weak var iconImage: UIImageView!
    //用户名
    @IBOutlet weak var nameLabel: UILabel!
    //总单数
    @IBOutlet weak var propertyNumber: UILabel!
    @IBOutlet weak var yuanLabel: UILabel!
    //总公斤数
    @IBOutlet weak var integralLabel: UILabel!
    @IBOutlet weak var fenLabel: UILabel!

    //退出登录
    @IBOutlet weak var logoutButton: UIButton!
    //登录
//    @IBOutlet weak var loginBtn: UIButton!
    //注册
    @IBOutlet weak var register: UIButton!
    //跳转按钮
    @IBOutlet weak var pushBtn: UIButton!
    //资金按钮
    @IBOutlet weak var myPropertyBtn: UIButton!
    //个人cell的背景颜色
    @IBOutlet weak var personBackgroud: UIView!
    @IBOutlet weak var propertyBackgroud: UIView!
    @IBOutlet weak var integralBackground: UIView!
    @IBOutlet weak var integralButton: UIButton!
    
    @IBOutlet weak var memberImageView: UIImageView!
    
    lazy var numberFormatter:NumberFormatter = {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter
    }()
    
    let jumpNotifyDict = [1 : AppConst.NotifyDefine.jumpToDeal,
                          2 : AppConst.NotifyDefine.jumpToWithdraw,
                          3 : AppConst.NotifyDefine.jumpToRecharge,
                          4 : AppConst.NotifyDefine.jumpToFeedback,
                          5 : AppConst.NotifyDefine.jumpToMyMessage,
                          6 : AppConst.NotifyDefine.jumpToMyAttention,
                          7 : AppConst.NotifyDefine.jumpToMyWealtVC,
                          8 : AppConst.NotifyDefine.jumpToAttentionUs,
                          9 : AppConst.NotifyDefine.jumpToUserInfo]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentSize = CGSize(width: 0, height: 600.0)
        tableView.backgroundColor = UIColor(hexString: "#F5F5F5")
        personBackgroud.dk_backgroundColorPicker = DKColorTable.shared().picker(withKey: AppConst.Color.main)
        propertyBackgroud.backgroundColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.2)
        integralBackground.backgroundColor = UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.2)
//            loginBtn.dk_setTitleColorPicker(DKColorTable.shared().picker(withKey: AppConst.Color.auxiliary), for: .normal)
        register.dk_setTitleColorPicker(DKColorTable.shared().picker(withKey: AppConst.Color.auxiliary), for: .normal)
//        logoutButton.layer.borderWidth = 0.7
//        logoutButton.layer.borderColor = UIColor(hexString: "#cccccc").cgColor
        registerNotify()
        //更新token
//        AppDataHelper.instance().checkTokenLogin()

        requstTotalHistroy()
        initReceiveBalanceBlock()
        if checkLogin() {

            let info = GetUserInfo()
            info.requestPath = "/api/user/info.json"
            info.token = UserDefaults.standard.object(forKey: SocketConst.Key.token) as! String
            HttpRequestManage.shared().postRequestModel(requestModel: info, responseClass: UserInfoVCModel.self, reseponse: { [weak self] (result) in
                
                let model = result as! UserInfoVCModel
                self?.nameLabel.text = String.init(format: "%.2f", model.balance)
            }) { (error) in
                
            }
        }
      
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == AppConst.KVOKey.balance.rawValue {
            guard UserModel.share().currentUser != nil else { return }
//            setBalanceText(balance: (UserModel.share().currentUser?.balance)!)
            nameLabel.text = formatMoneyString(balance: (UserModel.share().currentUser?.balance)! )
            nameLabel.adjustsFontSizeToFitWidth = true

        }
        
    }
    
    func formatMoneyString(balance:Double) -> String? {
       let str = numberFormatter.string(from: NSNumber(value: balance))
        return str?.components(separatedBy: "￥").last?.components(separatedBy: "¥").last?.components(separatedBy: "$").last
    }
    
    func setBalanceText(balance:Double) {
        nameLabel.text = formatMoneyString(balance: balance)
        if balance > 999999.0 {
            nameLabel.adjustsFontSizeToFitWidth = true
        }
        ShareModel.share().userMoney = balance
        DispatchQueue.main.async {
            UserModel.updateUser(info: { (result)-> ()? in
                UserModel.share().currentUser?.balance = balance
            })
        }
    }
    

    func initReceiveBalanceBlock() {
        SocketRequestManage.shared.receiveBalanceBlock = { (response) in
            let jsonResponse = response as! SocketJsonResponse
            let json = jsonResponse.responseJsonObject()
            if let result = json as? Dictionary<String,Any> {
                if let balance = result["balance"] as? Double {
                    self.setBalanceText(balance: balance)
                }
            }
            return nil
        }
        
    }
    
    func requstTotalHistroy() {
        
    }
    //MARK: -- 添加通知
    func registerNotify() {
        let notificationCenter = NotificationCenter.default
        //退出登录
        notificationCenter.addObserver(self, selector: #selector(quitEnterClick), name: NSNotification.Name(rawValue: AppConst.NotifyDefine.QuitEnterClick), object: nil)
        //登录成功
        notificationCenter.addObserver(self, selector: #selector(updateUI), name: NSNotification.Name(rawValue: AppConst.NotifyDefine.UpdateUserInfo), object: nil)
        //修改个人信息
        notificationCenter.addObserver(self, selector: #selector(changeUserinfo), name: NSNotification.Name(rawValue: AppConst.NotifyDefine.ChangeUserinfo), object: nil)
        
    }
    //修改个人信息
    func changeUserinfo() {
        
        if ((UserModel.share().getCurrentUser()?.avatarLarge) != ""){
            iconImage.image = UIImage(named: (UserModel.share().getCurrentUser()?.avatarLarge) ?? "")
            iconImage.image = UIImage(named: "default-head")
        }
        else{
            iconImage.image = UIImage(named: "default-head")
        }
        
        if ((UserModel.share().getCurrentUser()?.screenName) != "") {
            nameLabel.text = UserModel.share().getCurrentUser()?.screenName
            nameLabel.sizeToFit()
        }
        else{
            nameLabel.text = ""
        }
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
    //登录成功
    func updateUI()  {
        
        loginSuccessIs(bool: true)
        memberImageView.isHidden = UserModel.share().getCurrentUser()?.type == 0
        //用户余额数据请求
        let info = GetUserInfo()
        info.requestPath = "/api/user/info.json"
        info.token = UserDefaults.standard.object(forKey: SocketConst.Key.token) as! String
        HttpRequestManage.shared().postRequestModel(requestModel: info, responseClass: UserInfoVCModel.self, reseponse: { [weak self] (result) in
            
            let model = result as! UserInfoVCModel
            self?.nameLabel.text = String.init(format: "%.2f", model.balance)
        }) { (error) in
            
        }
        UserModel.share().currentUser?.addObserver(self, forKeyPath: AppConst.KVOKey.balance.rawValue, options: .new, context: nil)

//        AppAPIHelper.user().accinfo(complete: {[weak self](result) -> ()? in
//
//            if let object = result as? Dictionary<String,Any> {
//                if let  money =  object["balance"] as? Double {
//                self?.setBalanceText(balance: money)
//                } else {
//                    self?.nameLabel.text =  "0.00"
//                }
//            }
//
//            return nil
//            }, error: errorBlockFunc())

    }
    
    func quitEnterClick() {
        loginSuccessIs(bool: false)
        iconImage.image = UIImage(named: "default-head.png")
    }
    
    //MARK: -- 判断是否登录成功
    func loginSuccessIs(bool:Bool){
        nameLabel.isHidden = bool ? false : true
        yuanLabel.isHidden = bool ? false : true
//        concealLabel.isHidden = bool ? true : false
//        loginBtn.isHidden = bool ? true : false
        register.isHidden = bool ? true : false
        pushBtn.isHidden = bool ? false : true
        myPropertyBtn.isHidden = bool ? false : true
        propertyNumber.isHidden = bool ? false : true
    }
   
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 5 {
            
            return 10
        }
        return 0
    }
    //登录按钮
    @IBAction func logout(_ sender: Any) {
        AppDataHelper.instance().clearUserInfo()
        sideMenuController?.toggle()
    }
    @IBAction func enterDidClick(_ sender: Any) {
        
        if checkLogin() {
            
        }
        
    }
    //注册按钮
    @IBAction func registerDidClick(_ sender: Any) {
        
        let homeStoryboard = UIStoryboard.init(name: "Login", bundle: nil)
        let nav: UINavigationController = homeStoryboard.instantiateInitialViewController() as! UINavigationController
        let controller = homeStoryboard.instantiateViewController(withIdentifier: RegisterVC.className())
        controller.title = "注册"
        nav.pushViewController(controller, animated: true)
        present(nav, animated: true, completion: nil)
        
    }
    @IBAction func myMessageDidClick(_ sender: Any) {
        jumpToMyMessageController()
    }
    //我的积分
    @IBAction func myIntegral(_ sender: Any) {
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        
       return UserInfoVCModel.share().getCurrentUser()?.userType == 0 ? 2 : 1
       
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            
            jumpToMyMessageController()
            return
        }
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                jumpToDealController()
            }
           
        }
         //进入提现
        if indexPath.section == 2 {
            jumpToWithdraw()
        }
         //进入充值
        if indexPath.section == 3 {
            jumpToRecharge()
        }
        //进入充值列表
        if indexPath.section == 4 {
            let story = UIStoryboard.init(name: "Deal", bundle: nil)
            let AddFlightVC = story.instantiateViewController(withIdentifier: "AddFlightVC")
            self.navigationController?.pushViewController(AddFlightVC, animated: true)
        }
    }
    
    deinit {
        UserModel.share().currentUser?.removeObserver(self, forKeyPath: "balance")
        NotificationCenter.default.removeObserver(self)
    }
    
    func jumpToMyMessageController() {
        
    
        if checkLogin() {
            
            let stroyBoard = UIStoryboard(name: "User", bundle: nil)
            let vc = stroyBoard.instantiateViewController(withIdentifier: "UserInfoVC")
            _ = navigationController?.pushViewController(vc, animated: true)
            
        }
      
    }
    func jumpToRecharge() {
        
        if checkLogin() {
            
            let stroyBoard = UIStoryboard(name: "Share", bundle: nil)
            let vc = stroyBoard.instantiateViewController(withIdentifier: "RechargeVC")
            _ = navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    func jumpToWithdraw() {
        if checkLogin() {
            let stroyBoard = UIStoryboard(name: "Share", bundle: nil)
            let vc = stroyBoard.instantiateViewController(withIdentifier: "WithDrawalVC")
            _ = navigationController?.pushViewController(vc, animated: true)
        }
    }
    //我的交易明细
    func jumpToDealController() {
//        if checkLogin() {
//            self.performSegue(withIdentifier: DealController.className(), sender: nil)
//        }
    }
    func jumpToMyWealtVC() {
        let story : UIStoryboard = UIStoryboard.init(name: "Share", bundle: nil)
        let wealth  = story.instantiateViewController(withIdentifier: MyWealtVC.className())
        navigationController?.pushViewController(wealth, animated: true)
    }
    
}
