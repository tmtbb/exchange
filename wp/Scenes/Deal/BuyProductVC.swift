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
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var feeLabel: UILabel!
    @IBOutlet weak var buyBtn: UIButton!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var cangWeiLabel: UILabel!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var resultBlock: CompleteBlock?
    
    enum BuyResultType: Int {
        case success = 0
        case cancel = 1
        case lessMoney = 3
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        let residueCountText = "当前仓位剩余数量 200"
        residueCountLabel.setAttributeText(text: residueCountText, firstFont: 14.0, secondFont: 18.0, firstColor: UIColor(hexString:"666666"), secondColor: UIColor(hexString: "157FB3"), range: NSMakeRange(9, residueCountText.length() - 9))
        
        
        let priceText = "此次成交额￥20.5"
        priceLabel.setAttributeText(text: priceText, firstFont: 16.0, secondFont: 20.0, firstColor: UIColor(hexString:"666666"), secondColor: UIColor(hexString: "157FB3"), range:NSMakeRange(5, priceText.length() - 5))
        
        
        
        let text = "当前舱位航班 : FB2313"
        cangWeiLabel.setAttributeText(text: text, firstFont: 16.0, secondFont: 16.0, firstColor: UIColor(hexString: "666666"), secondColor: UIColor(hexString: "333333"), range: NSMakeRange(9, text.length() - 9))
        requestShippingSpaceInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SVProgressHUD.dismiss()
    }
    
    func requestShippingSpaceInfo() {
        return
        let positionParm = PositionParam()
        positionParm.gid = DealModel.share().buyProduct!.id
        AppAPIHelper.deal().position(param: positionParm, complete: { [weak self](result) -> ()? in
            if let model = result as? ProductPositionModel {
             let text = "当前舱位航班 : \(model.name)"
             self?.cangWeiLabel.setAttributeText(text: text, firstFont: 16.0, secondFont: 16.0, firstColor: UIColor(hexString: "666666"), secondColor: UIColor(hexString: "333333"), range: NSMakeRange(9, text.length() - 0))
            }
            return nil
        }, error: errorBlockFunc())
        
    }
    
    func initUI() {
        contentView.layer.cornerRadius = 3
        contentView.layer.masksToBounds = true
        
    }
    

    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismissController()
    }
    
    @IBAction func buyBtnTapped(_ sender: UIButton) {

        view.isUserInteractionEnabled = false
        SVProgressHUD.showProgressMessage(ProgressMessage: "交易中...")
        let buyModel: BuildDealParam = BuildDealParam()
        buyModel.codeId = DealModel.share().buyProduct!.id
        buyModel.buySell = DealModel.share().dealUp ? 1 : -1
        //buyModel.amount = Int(countSlider.value)
        buyModel.isDeferred = DealModel.share().buyModel.isDeferred

        AppAPIHelper.deal().buildDeal(model: buyModel, complete: { [weak self](result) -> ()? in
            SVProgressHUD.dismiss()
            self?.view.isUserInteractionEnabled = true
            if let product: PositionModel = result as? PositionModel{
                self?.dismissController()
                if self?.resultBlock != nil{
                    self?.resultBlock!(BuyResultType.success as AnyObject)
                }
                DealModel.cachePosition(position: product)
                YD_CountDownHelper.shared.reStart()
            }
            return nil
        }) { (error) -> ()? in
            self.didRequestError(error)
            self.view.isUserInteractionEnabled = true
            return nil
        }
        
        
    }
    
}
