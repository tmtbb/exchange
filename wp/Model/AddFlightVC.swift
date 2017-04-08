//
//  AddFlightVC.swift
//  wp
//
//  Created by sum on 2017/3/28.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
import DKNightVersion
extension UITextField {
    func setBorder() {
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexString: "cccccc").cgColor
    }
}
class AddFlightVC: UIViewController ,UIPickerViewDelegate,  UIPickerViewDataSource, UIScrollViewDelegate{
    var dataSource:[AirLineModel]?
    private var timer: Timer?
    private var codeTime = 60
    var autoCode:String?
    //定义pickerView
    var pickView = UIPickerView()
    //定义显示下面的tabbar
    var myToolBar = UIToolbar()
    var dateToolBar = UIToolbar()
    
    @IBOutlet weak var codeBtn: UIButton!
    var time : String = ""
    // 用来判断选择的第几区 然后渲染数据
    var selectRow : Int = 0
    // 时间lab
    @IBOutlet weak var timeTF: UITextField!
    var datePicker = UIDatePicker()
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var selectFlight: UITextField!
    @IBOutlet weak var flightTextField: UITextField!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var moneyTextField: UITextField!
    @IBOutlet weak var authCodeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "添加航班线路"
        initUI()
        initdatePicker()
        
    }

    func initdatePicker(){
        
        timeTF.setBorder()
        datePicker =  UIDatePicker.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.size.width, height: 120))
         timeTF.inputView = datePicker
        dateToolBar = UIToolbar.init(frame:  CGRect.init(x: 0, y: self.view.frame.size.height - self.dateToolBar.frame.size.height - 44.0, width: self.view.frame.size.width, height: 44))
       
        timeTF.inputAccessoryView = dateToolBar
        
        let local = Locale.init(identifier: "zh_CN")
        datePicker.locale = local
        datePicker.datePickerMode = .time
        datePicker.addTarget(self, action: #selector(dateValueChange(_:)), for: .valueChanged)
        let sure : UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 44))
        sure.setTitle("确定", for: .normal)
        let sureItem : UIBarButtonItem = UIBarButtonItem.init(customView: sure)
        sure.setTitleColor(UIColor.init(hexString: "666666"), for: .normal)
        let space : UIButton = UIButton.init(frame: CGRect.init(x: 40, y: 0, width: self.view.frame.size.width-140, height: 44))
        space.setTitle("", for: .normal)
        sure.addTarget(self, action: #selector(datesureClick), for: .touchUpInside)
        let spaceItem : UIBarButtonItem = UIBarButtonItem.init(customView: space)
        let cancel : UIButton = UIButton.init(frame: CGRect.init(x: self.view.frame.size.width-44, y: 0, width: 40, height: 44))
        cancel.setTitle("取消", for: .normal)
        cancel.addTarget(self, action: #selector(datecancelClick), for: .touchUpInside)
        cancel.setTitleColor(UIColor.init(hexString: "666666"), for: .normal)
        cancel.setTitleColor(UIColor.init(hexString: "666666"), for: .normal)
        let cancelItem : UIBarButtonItem = UIBarButtonItem.init(customView: cancel)
        dateToolBar.setItems([sureItem,spaceItem,cancelItem], animated: true)
        
      
        
        
    }
    func dateValueChange(_ pickerView : AnyObject){
        let picker = pickerView as! UIDatePicker
        
//        print("Selected date = \(picker.date)")
          time =      Date.yt_convertDateToStr(picker.date, format: "HH:mm")
        
    }
    func initUI(){
        selectFlight.setBorder()
        flightTextField.setBorder()
        countTextField.setBorder()
        moneyTextField.setBorder()
        authCodeTextField.setBorder()
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(scrollViewDidScroll(_:)))
            
        contentView.addGestureRecognizer(tapGes)
        pickView = UIPickerView.init()
        
        pickView.delegate = self
        
        pickView.dataSource = self
        
        myToolBar = UIToolbar.init(frame:  CGRect.init(x: 0, y: self.view.frame.size.height - self.myToolBar.frame.size.height - 44.0, width: self.view.frame.size.width, height: 44))
        
        selectFlight.inputView = pickView
        selectFlight.inputAccessoryView = myToolBar
        
        let sure : UIButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 40, height: 44))
        sure.setTitle("确定", for: .normal)
        let sureItem : UIBarButtonItem = UIBarButtonItem.init(customView: sure)
        sure.setTitleColor(UIColor.init(hexString: "666666"), for: .normal)
        let space : UIButton = UIButton.init(frame: CGRect.init(x: 40, y: 0, width: self.view.frame.size.width-140, height: 44))
        space.setTitle("", for: .normal)
        sure.addTarget(self, action: #selector(sureClick), for: .touchUpInside)
        let spaceItem : UIBarButtonItem = UIBarButtonItem.init(customView: space)
        let cancel : UIButton = UIButton.init(frame: CGRect.init(x: self.view.frame.size.width-44, y: 0, width: 40, height: 44))
        cancel.setTitle("取消", for: .normal)
        cancel.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        cancel.setTitleColor(UIColor.init(hexString: "666666"), for: .normal)
        cancel.setTitleColor(UIColor.init(hexString: "666666"), for: .normal)
        let cancelItem : UIBarButtonItem = UIBarButtonItem.init(customView: cancel)
        myToolBar.setItems([sureItem,spaceItem,cancelItem], animated: true)
        
        
        requestRouteList()
        
    }
    
    func requestRouteList() {
        
        let model = TokenRequestModel()
        model.requestPath = "/api/route/index.json"
        model.token = UserDefaults.standard.value(forKey: SocketConst.Key.token) as! String
        HttpRequestManage.shared().postRequestModels(requestModel: model, responseClass: AirLineModel.self, reseponse: { (responseObject) in
            if let array = responseObject as? [AirLineModel] {
                self.dataSource = array
                self.pickView.reloadAllComponents()
            }
        }) { (error) in
            
        }
    }
    func sureClick(){
    
        let model = dataSource?[selectRow]

        selectFlight.text = model?.routeName
        UIView.animate(withDuration: 0.23) { 
            self.selectFlight.resignFirstResponder()
        }
    }
    func cancelClick(){
        UIView.animate(withDuration: 0.23) {
            self.selectFlight.resignFirstResponder()
        }
      
    }
    func datesureClick(){
        
        if time == ""{
        
            let date = Date()
            time = Date.yt_convertDateToStr(date, format: "HH:mm")
        }
         timeTF.text = time
        
        
//        let model = dataSource?[selectRow]
        
//        selectFlight.text = model?.routeName
        
        UIView.animate(withDuration: 0.23) {
           self.timeTF.resignFirstResponder()
        }
    }
    func datecancelClick(){
        UIView.animate(withDuration: 0.23) {
            self.timeTF.resignFirstResponder()
        }
        
    }
    // MARK: - PickViewdataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource == nil ? 0 : dataSource!.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       
        let model = dataSource?[row]
        return model?.routeName
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectRow = row
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        contentView.endEditing(true)
    }
   
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        contentView.endEditing(true)
    }

    @IBAction func getAuthCode(_ sender: Any) {
        
        AppDataHelper.instance().getVailCode(phone: (UserInfoVCModel.share().getCurrentUser()?.phoneNum)!, type: 1) { [weak self](response) in
            if let dict = response as? Dictionary<String,AnyObject> {
                
                
                if let strongSelf = self{
                    self?.autoCode = dict["codeToken"] as? String
                    SVProgressHUD.showInfo(withStatus: "验证码已发送")
                    
                    strongSelf.codeBtn.isEnabled = false
                    strongSelf.timer = Timer.scheduledTimer(timeInterval: 1, target: strongSelf, selector: #selector(strongSelf.updatecodeBtnTitle), userInfo: nil, repeats: true)
                }
              
            }
            
        }
    }
    
    @IBAction func addFlightVC(_ sender: Any) {
        guard autoCode != nil else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请获取验证码", ForDuration: 1.5, completion: nil)
            return
        }
        
        guard flightTextField.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请输入航班号", ForDuration: 1.5, completion: nil)
            return
        }
        
        guard moneyTextField.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请输入舱位价格", ForDuration: 1.5, completion: nil)
            return
        }
        
        guard countTextField.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请输入舱位数量", ForDuration: 1.5, completion: nil)
            return
        }
        guard authCodeTextField.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请输入验证码", ForDuration: 1.5, completion: nil)
            return
        }
        guard timeTF.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请选择时间", ForDuration: 1.5, completion: nil)
            return
        }
        
        if let selectModel = dataSource?[selectRow] {
            let model = AddFlightModel()
            model.token = UserDefaults.standard.value(forKey: SocketConst.Key.token) as! String
            model.requestPath = "/api/route/flight/add.json"
            model.routeId = selectModel.routeId
            model.flightNumber = flightTextField.text!
            model.flightSpacePrice = Double(moneyTextField.text!)!
            model.flightSpaceNumber = Int(countTextField.text!)!
            model.phoneNum = (UserInfoVCModel.share().getCurrentUser()?.phoneNum)!
            model.phoneCode = authCodeTextField.text!
            model.codeToken = autoCode!
            model.flightTime = time
            HttpRequestManage.shared().postRequestModelWithJson(requestModel: model, reseponse: { (resonseObject) in
                SVProgressHUD.showSuccess(withStatus: "添加成功")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.UpdateUserInfo), object: nil)
                _ = self.navigationController?.popViewController(animated: true)
            }) { (error) in
                
            }
        }
        

    }
    
   
    func updatecodeBtnTitle() {
        if codeTime == 0 {
            codeBtn.isEnabled = true
            codeBtn.setTitle("重新发送", for: .normal)
            codeTime = 60
            timer?.invalidate()
            codeBtn.dk_backgroundColorPicker = DKColorTable.shared().picker(withKey: AppConst.Color.main)
            return
        }
        codeBtn.isEnabled = false
        codeTime = codeTime - 1
        let title: String = "\(codeTime)秒后重新发送"
        codeBtn.setTitle(title, for: .normal)
        codeBtn.backgroundColor = UIColor.init(rgbHex: 0xCCCCCC)
    }
    func addFlight() {
        
        guard flightTextField.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请输入航班号", ForDuration: 1.5, completion: nil)
            return
        }
        
        guard moneyTextField.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请输入舱位价格", ForDuration: 1.5, completion: nil)
            return
        }
        
        guard countTextField.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请输入舱位数量", ForDuration: 1.5, completion: nil)
            return
        }
        guard autoCode?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请获取验证码", ForDuration: 1.5, completion: nil)
            return
        }
        guard authCodeTextField.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请输入验证码", ForDuration: 1.5, completion: nil)
            return
        }
        guard timeTF.text?.length() != 0 else {
            SVProgressHUD.showWainningMessage(WainningMessage: "请选择时间", ForDuration: 1.5, completion: nil)
            return
        }

        
        if let selectModel = dataSource?[selectRow] {
            let model = AddFlightModel()
            model.token = UserDefaults.standard.value(forKey: SocketConst.Key.token) as! String
            model.requestPath = "/api/route/flight/add.json"
            model.routeId = selectModel.routeId
            model.flightNumber = flightTextField.text!
            model.flightSpacePrice = Double(moneyTextField.text!)!
            model.flightSpaceNumber = Int(countTextField.text!)!
            model.phoneNum = (UserInfoVCModel.share().getCurrentUser()!.phoneNum)
            model.phoneCode = "111111"
            model.codeToken = autoCode!
            HttpRequestManage.shared().postRequestModelWithJson(requestModel: model, reseponse: { (resonseObject) in
                _  = self.navigationController?.popViewController(animated: true)
            }) { (errpr) in
                
            }
        }
    }
    
}
