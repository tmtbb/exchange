//
//  DealVC.swift
//  wp
//
//  Created by 木柳 on 2016/12/25.
//  Copyright © 2016年 com.yundian. All rights reserved.
//

import UIKit
import SVProgressHUD
import DKNightVersion
import Realm
import RealmSwift

class DealVC: BaseTableViewController, TitleCollectionviewDelegate {
    @IBOutlet weak var listTable: UITableView!
    
    @IBOutlet weak var myMoneyLabel: UILabel!
    @IBOutlet weak var myMoneyView: UIView!
    @IBOutlet weak var titleView: TitleCollectionView!

    private var rowHeights: [CGFloat] = [40,50,UIScreen.main.bounds.size.height - 60.0 - 108.0 - 90.0,60,200,41,70,35,200]
    private var priceTimer: Timer?
    
    var selectAirLine:AirLineModel?
    
    lazy var listDataSource:ListDataSource = {
    
        let datsSouce = ListDataSource()
        
        return datsSouce
    }()
    
    //MARK: --Test
    @IBAction func testItemTapped(_ sender: Any) {
        refreshUserCash()

    }
    //MARK: --LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        initData()
        
        initUI()
        initKVOAndNotice()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        showTabBarWithAnimationDuration()
        requestRouteList()
        self.myMoneyLabel.text = "\(UserInfoVCModel.share().getCurrentUser()!.balance)"
        refreshTitleView()
        upDataUserInfo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    deinit {
        DealModel.share().removeObserver(self, forKeyPath: AppConst.KVOKey.allProduct.rawValue)
        NotificationCenter.default.removeObserver(self)
        priceTimer?.invalidate()
        priceTimer = nil
    }
    //MARK: --DATA
    func initData() {

        requestRouteList()
    }
    func requestRouteList() {
    
        if let _ = UserDefaults.standard.value(forKey: SocketConst.Key.token) as? String   {
            let model = TokenRequestModel()
            model.requestPath = "/api/route/index.json"
            model.token = UserDefaults.standard.value(forKey: SocketConst.Key.token) as! String
            HttpRequestManage.shared().postRequestModels(requestModel: model, responseClass: AirLineModel.self, reseponse: { (responseObject) in
                if let array = responseObject as? [AirLineModel] {
                    self.titleView.objects = array
                }
            }) { (error) in
                
            }
        }
    }

    func requestFlightInfo() {
        let model = RequestFlightModel()
        model.routeId = selectAirLine == nil ? 10001 : selectAirLine!.routeId
        model.token = UserDefaults.standard.value(forKey: SocketConst.Key.token) as! String
        model.requestPath = "/api/route/flights.json"
        HttpRequestManage.shared().postRequestModels(requestModel: model, responseClass: FlightModel.self, reseponse: { (responseObject) in
            if let dataArray = responseObject as? [FlightModel] {
                self.listDataSource.dataArray = dataArray
                self.listDataSource.selectIndex = 0
                self.listTable.reloadData()
            }
        }) { (error) in
            
        }
        
    }
    func initKVOAndNotice(){
        DealModel.share().addObserver(self, forKeyPath: AppConst.KVOKey.allProduct.rawValue, options: .new, context: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTitleView), name: NSNotification.Name(rawValue: AppConst.NotifyDefine.SelectKind), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshUserCash), name: Notification.Name(rawValue:AppConst.NotifyDefine.UpdateUserInfo), object: nil)
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if keyPath == AppConst.KVOKey.allProduct.rawValue{
            let allProducets: [ProductModel] = DealModel.share().productKinds
            titleView.objects = allProducets
        }
    }
    //用户余额数据请求
    func refreshUserCash() {

    }
    //我的资产
    @IBAction func jumpToMyWallet(_ sender: AnyObject) {
        if checkLogin(){
            let storyboard = UIStoryboard.init(name: "Share", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: MyWealtVC.className())
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    //TitleCollectionView's Delegate
    func refreshTitleView() {
        titleView.selectIndexPath = IndexPath.init(row: DealModel.share().selectProductIndex, section: 0)
        didSelectedObject(titleView, object: DealModel.share().selectProduct)
    }
    
    internal func didSelectedObject(_ collectionView: UICollectionView, object: AnyObject?) {
        selectAirLine = object as? AirLineModel
       requestFlightInfo()
    }
    //刷新商品数据
    func reloadProducts() {
        var products: [ProductModel] = []
        for product in DealModel.share().allProduct {
            if product.symbol == DealModel.share().selectProduct!.symbol{
                products.append(product)
            }
        }
        DealModel.share().productKinds = products
        listDataSource.selectIndex = 0
        DealModel.share().buyProduct = products.first
        listTable.reloadData()
    }

    //MARK: --UI
    func initUI() {


        
        myMoneyView.dk_backgroundColorPicker = DKColorTable.shared().picker(withKey: AppConst.Color.main)
        titleView.itemDelegate = self
        titleView.reuseIdentifier = ProductTitleItem.className()
        tableView.isScrollEnabled = false
        listTable.dataSource = listDataSource
        listTable.delegate = listDataSource
        listTable.separatorStyle = .none
        }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeights[indexPath.row]
    }
    //MARK: --买涨/买跌
    @IBAction func dealBtnTapped(_ sender: UIButton) {
        tableView.scrollToRow(at: IndexPath.init(row: 3, section: 0), at: .top, animated: false)
        if checkLogin(){
            if titleView.objects?.count == 0 {
                SVProgressHUD.showWainningMessage(WainningMessage: "暂无航班信息", ForDuration: 1.5, completion: nil)
                return
            }
            
            let controller = UIStoryboard.init(name: "Deal", bundle: nil).instantiateViewController(withIdentifier: BuyProductVC.className()) as! BuyProductVC
            controller.flightModel = listDataSource.dataArray?[listDataSource.selectIndex]
            controller.modalPresentationStyle = .custom
            controller.modalTransitionStyle = .crossDissolve
            controller.resultBlock = { [weak self](result) in
                self?.requestRouteList()
                self?.upDataUserInfo()
                return nil
            }
            present(controller, animated: true, completion: nil)
            
        }
    }
    
    
    func upDataUserInfo() {
        let info = GetUserInfo()
        info.requestPath = "/api/user/info.json"
        
        info.token = UserDefaults.standard.object(forKey: SocketConst.Key.token) as? String  == nil ? "" : (UserDefaults.standard.object(forKey: SocketConst.Key.token) as! String)
        HttpRequestManage.shared().postRequestModel(requestModel: info, responseClass: UserInfoVCModel.self, reseponse: { (result) in
            if let model = result as? UserInfoVCModel {
                UserInfoVCModel.share().currentUserId = model.userId
                UserDefaults.standard.setValue( UserInfoVCModel.share().currentUserId, forKey: SocketConst.Key.uid)
                UserDefaults.standard.setValue( UserInfoVCModel.share().currentUserId, forKey: SocketConst.Key.uid)
                let realm = try! Realm()
                try! realm.write {
                    realm.add(model, update: true)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: AppConst.NotifyDefine.UpdateUserInfo), object: nil)
                }
                self.myMoneyLabel.text = "\(UserInfoVCModel.share().getCurrentUser()!.balance)"
            }
        }) { (error) in
            
        }
    }
    
}
extension DealVC{
    
    // 当前报价
    func initRealTimeData() {
        if let product = DealModel.share().selectProduct {
            let good = [SocketConst.Key.aType: SocketConst.aType.currency.rawValue,
                        SocketConst.Key.exchangeName: product.exchangeName,
                        SocketConst.Key.platformName: product.platformName,
                        SocketConst.Key.symbol: product.symbol] as [String : Any]
            let param: [String: Any] = [SocketConst.Key.id: UserModel.share().currentUserId,
                                        SocketConst.Key.token: UserModel.share().token,
                                        SocketConst.Key.symbolInfos: [good]]
            AppAPIHelper.deal().realtime(param: param, complete: { [weak self](result) -> ()? in
                if let models: [KChartModel] = result as! [KChartModel]?{
                    for model in models{
                        if model.symbol == product.symbol{
                            self?.updateNewPrice(model: model)
                        }
                    }
                }
                return nil
                }, error: errorBlockFunc())
        }
    }
    
    func updateNewPrice(model: KChartModel) {
        updatePrice(price: model.currentPrice)
    }
    

    
    
    func updatePrice(price: Double) {
        for product in DealModel.share().allProduct {
            if product.symbol == DealModel.share().selectProduct!.symbol {
                product.price = price * product.depositFee
            }
        }
    }
}

class ListDataSource:NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var dataArray:[FlightModel]?
    var selectIndex = 0
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray == nil ? 0 : dataArray!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == selectIndex {
            return 100
        }
        return 44
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row != selectIndex else { return }
        let index = selectIndex
        selectIndex = indexPath.row
       // DealModel.share().buyProduct = DealModel.share().productKinds[selectIndex]
        tableView.reloadRows(at: [indexPath,IndexPath(row: index, section: 0)], with: .fade)
        

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dealCell", for: indexPath) as! DealCell
        
        cell.setInfo(flightModel: dataArray![indexPath.row])
        cell.setIsSelect(isSelect: indexPath.row == selectIndex)
        return cell
    }
    
}
