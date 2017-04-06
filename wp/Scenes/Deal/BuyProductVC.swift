//
//  BuyProductVC.swift
//  wp
//
//  Created by mu on 2017/2/9.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import DKNightVersion
import SVProgressHUD
class BuyProductVC: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var residueCountLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    
    @IBOutlet weak var minCountLabel: UILabel!
    @IBOutlet weak var maxCountLabel: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cangWeiLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var resultBlock: CompleteBlock?
    var flightModel:FlightModel?
    enum BuyResultType: Int {
        case success = 0
        case cancel = 1
        case lessMoney = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        let residueCountText = "当前仓位剩余数量 \(flightModel!.flightSpaceNumber)"
        residueCountLabel.setAttributeText(text: residueCountText, firstFont: 14.0, secondFont: 18.0, firstColor: UIColor(hexString:"666666"), secondColor: UIColor(hexString: "157FB3"), range: NSMakeRange(9, residueCountText.length() - 9))
        
        
        let priceText = "此次成交额￥0.0"
        priceLabel.setAttributeText(text: priceText, firstFont: 16.0, secondFont: 20.0, firstColor: UIColor(hexString:"666666"), secondColor: UIColor(hexString: "157FB3"), range:NSMakeRange(5, priceText.length() - 5))
        
        
        
        let text = "当前舱位航班 : \(flightModel!.flightNumber)"
        cangWeiLabel.setAttributeText(text: text, firstFont: 16.0, secondFont: 16.0, firstColor: UIColor(hexString: "666666"), secondColor: UIColor(hexString: "333333"), range: NSMakeRange(9, text.length() - 9))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    
    func initUI() {
        contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = true
        
    }
    

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismissController()
    }
    
    @IBAction func buyBtnTapped(_ sender: UIButton) {

        guard flightModel != nil else {return}
        view.isUserInteractionEnabled = false
        let model = BuyPositionModel()
        model.requestPath = "/api/trade/flight/buy.json"
        model.flightId = flightModel!.flightId
        model.flightNumber = flightModel!.flightNumber
        model.flightSpacePrice = flightModel!.flightSpacePrice
        model.buyNum = Int(countTextField.text!)!
        
        HttpRequestManage.shared().postRequestModelWithJson(requestModel: model, reseponse: { (responseObject) in
            self.view.isUserInteractionEnabled = true
            self.dismissController()

        }) { (error) in
            self.view.isUserInteractionEnabled = true
            self.dismissController()

        }

        
    }
    
}
