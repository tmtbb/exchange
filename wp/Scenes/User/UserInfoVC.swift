//
//  UserInfoVC.swift
//  wp
//
//  Created by sum on 2017/3/27.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit

class UserInfoVCCell: UITableViewCell {
    
    @IBOutlet weak var rightLb: UILabel!
    
    @IBOutlet weak var leftLb: UILabel!
    
    
}
class UserInfoVC: BaseTableViewController {

    var titltArr = [String]()
    var Model = UserInfoVCModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
      
        initData()
    }
    
     // MARK: - Init Data
    
    func initData(){
    
        let info = GetUserInfo()
        info.requestPath = "/api/user/info.json"
        info.token = UserDefaults.standard.object(forKey: SocketConst.Key.token) as! String
        HttpRequestManage.shared().postRequestModel(requestModel: info, responseClass: UserInfoVCModel.self, reseponse: { [weak self](result) in
            self?.tableView.reloadData()
            let model =  result as! UserInfoVCModel
            self?.titltArr = model.userType == 0 ? ["真实姓名","身份证号码","手机号码"] : ["企业名称","手机号码","组织机构代码","qiyeyoux"]
            self?.title = model.userType == 0 ? "个人信息" : "企业信息"
            self?.Model = model
            
        }) { (error) in
            
        }

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func didRequest() {
        
    }
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return titltArr.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
       let cell : UserInfoVCCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoVCCell", for: indexPath) as! UserInfoVCCell
       cell.selectionStyle = .none
       cell.leftLb.text = titltArr[indexPath.row]
        if indexPath.row == 0 {
            cell.rightLb.text = Model.name
        }
        if indexPath.row == 1 {
            
        }
        
        if indexPath.row == 2 {
            
        }

        if indexPath.row == 3 {
            
        }

       return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }
    
    @IBAction func loginOut(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        _ = self.navigationController?.popToRootViewController(animated: true)
        AppDataHelper.instance().clearUserInfo()
        
    }


}
