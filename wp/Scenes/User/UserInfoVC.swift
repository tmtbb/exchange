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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titltArr = UserModel.share().getCurrentUser()?.userType == 0 ? ["真实姓名","身份证号码","手机号码"] : ["企业名称","手机号码","组织机构代码","qiyeyoux"]
        title = UserModel.share().getCurrentUser()?.userType == 0 ? "个人信息" : "企业信息"
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
       cell.rightLb.text = titltArr[indexPath.row]
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
