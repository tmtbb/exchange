//
//  AddFlightVC.swift
//  wp
//
//  Created by sum on 2017/3/28.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
extension UITextField {
    func setBorder() {
        
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexString: "cccccc").cgColor
    }
}
class AddFlightVC: UIViewController ,UIPickerViewDelegate,  UIPickerViewDataSource, UIScrollViewDelegate{
    var dataSource:[AirLineModel]?
    var autoCode:String?
    //定义pickerView
    var pickView = UIPickerView()
    //定义显示下面的tabbar
    var myToolBar = UIToolbar()
    // 用来判断选择的第几区 然后渲染数据
    var selectRow : Int = 0
    // 输入框
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
        
        AppDataHelper.instance().getVailCode(phone: "13958104695", type: 1) { (response) in
            if let dict = response as? Dictionary<String,AnyObject> {
                self.autoCode = dict["codeToken"] as? String
                SVProgressHUD.showInfo(withStatus: "验证码已发送")
            }
            
        }
    }
    
    @IBAction func addFlightVC(_ sender: Any) {
        guard autoCode != nil else {
            
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
            model.phoneNum = "13958104695"
            model.phoneCode = "111111"
            model.codeToken = autoCode!
            
            HttpRequestManage.shared().postRequestModelWithJson(requestModel: model, reseponse: { (resonseObject) in
                SVProgressHUD.showSuccess(withStatus: "添加成功")
                _ = self.navigationController?.popViewController(animated: true)
            }) { (error) in
                
            }
        }
        

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

        
        if let selectModel = dataSource?[selectRow] {
            let model = AddFlightModel()
            model.token = UserDefaults.standard.value(forKey: SocketConst.Key.token) as! String
            model.requestPath = "/api/route/flight/add.json"
            model.routeId = selectModel.routeId
            model.flightNumber = flightTextField.text!
            model.flightSpacePrice = Double(moneyTextField.text!)!
            model.flightSpaceNumber = Int(countTextField.text!)!
            model.phoneNum = (UserInfoVCModel.share().getCurrentUser()!.phoneNum)
            model.phoneCode = authCodeTextField.text!
            model.codeToken = autoCode!
            HttpRequestManage.shared().postRequestModelWithJson(requestModel: model, reseponse: { (resonseObject) in
                _  = self.navigationController?.popViewController(animated: true)
            }) { (errpr) in
                
            }
        }
    }
}
