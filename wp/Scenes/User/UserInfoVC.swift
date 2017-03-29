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

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return UserModel.share().getCurrentUser()?.userType == 0 ? 4 : 5
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UserInfoVCCell = tableView.dequeueReusableCell(withIdentifier: "UserInfoVCCell", for: indexPath) as! UserInfoVCCell

       cell.selectionStyle = .none
       cell.rightLb.text = "123"

        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let story = UIStoryboard.init(name: "User", bundle: nil)
        let AddFlightVC = story.instantiateViewController(withIdentifier: "AddFlightVC")
        
        self.navigationController?.pushViewController(AddFlightVC, animated: true)
    }
    
    @IBAction func loginOut(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        _ = self.navigationController?.popToRootViewController(animated: true)
        AppDataHelper.instance().clearUserInfo()
        
    }


}
