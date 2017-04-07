//
//  HistoryDealVC.swift
//  wp
//
//  Created by 木柳 on 2017/1/4.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import RealmSwift
import DKNightVersion

class HistoryDealCell: OEZTableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var failLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    // 盈亏
    @IBOutlet weak var statuslb: UILabel!
    enum PositionStatus:UInt8 {
        case unHandle = 3
        case reSet = 4
        case freight = 5
        case resell = 6
    }
    override func update(_ data: Any!) {
        if let model = data as? PoHistoryModel {
            print(model.description)
            nameLabel.text = "\(model.tradeGoodsName)"
            timeLabel.text = Date.yt_convertDateToStr(Date.init(timeIntervalSince1970: TimeInterval(model.tradeTime / 1000)), format: "yyyy.MM.dd HH:mm:ss")
           //com.yundian.trip
            priceLabel.text = "¥" + String(format: "%.2f", model.tradeTotalPrice)
            priceLabel.dk_textColorPicker = DKColorTable.shared().picker(withKey: AppConst.Color.main)
            

            statuslb.backgroundColor = model.tradeStatus == 3  ? UIColor.init(hexString: "999999") : UIColor.init(hexString: "0EAF56")
              handleLabel.backgroundColor = model.tradeStatus == 3  ? UIColor.init(hexString: "999999") : UIColor.init(hexString: "E9573F")
            
//            let timeCount = Int64(NSDate().timeIntervalSince1970) - (model.tradeTime / 1000)
//            if timeCount < 5 * 24 * 3600 {
//             statuslb.text = "不可交易"
//            } else {
            //            statuslb.text =  model.tradeStatus  > 3 ?  "已交易" :   "未交易"
//            }
            statuslb.text =  model.tradeStatus  > 3 ?  "已交易" :   "未交易"
            
//            titleLabel.text = model.buySell == 1 ? "买入" : "卖出"
            let handleText = [" 买入 "," 退舱 "," 货运 "," 转卖 "]
//
            handleLabel.text = handleText[model.tradeStatus - 3]

//
//            if model.buySell == -1 && UserModel.share().currentUser?.type == 0 && model.result == false{
//                handleLabel.backgroundColor = UIColor.clear
//                handleLabel.text = ""
//            }else if model.handle == 0{
//                handleLabel.backgroundColor = UIColor.init(rgbHex: 0xc2cfd7)
//            }else{
//                handleLabel.dk_backgroundColorPicker = DKColorTable.shared().picker(withKey: AppConst.Color.main)
//            }
        }
    }
}

class HistoryDealVC: BasePageListTableViewController {
    
    var historyModels: [PositionModel] = []
    //MARK: --LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPositionHistroy()
    }
    
    func requestPositionHistroy() {
        

        
    }
    override func didRequest(_ pageIndex: Int) {
       
        if let token = UserDefaults.standard.value(forKey: SocketConst.Key.token) as? String {
            let model = RequestHistroyModel()
            model.token = token
            if pageIndex == 1 {
                model.recordPos = 0
            } else {
                
                model.recordPos = (pageIndex - 1) * 10
            }
            model.requestPath = "/api/trade/user/flightspaces.json"
            HttpRequestManage.shared().postRequestModels(requestModel: model, responseClass: PoHistoryModel.self, reseponse: { (response) in
                self.didRequestComplete(response)
            }) { (error) in
                
            }
        }
        
        
    }
    
   
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        let model = dataSource![indexPath.row] as! PoHistoryModel
        
        if model.tradeStatus != 3 {
            return
        }
//        let timeCount = Int64(NSDate().timeIntervalSince1970) - (model.tradeTime / 1000)
//        if timeCount < 5 * 24 * 3600 {
//            return
//        }
        let controller = UIStoryboard.init(name: "Deal", bundle: nil).instantiateViewController(withIdentifier: HandlePositionVC.className()) as! HandlePositionVC
        controller.modalPresentationStyle = .custom
        controller.modalTransitionStyle = .crossDissolve
        controller.positionModel = (dataSource![indexPath.row] as! PoHistoryModel)
        present(controller, animated: true, completion: nil)
        controller.resultBlock = { [weak self](result) in
        
            self?.beginRefreshing()
            return nil
        }
        if let model = self.dataSource?[indexPath.row] as? PositionModel{
            print(model.handle)
            if model.handle != 0{
                return
            }

        }
    }
}
