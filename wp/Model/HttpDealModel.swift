//
//  HttpDealModel.swift
//  wp
//
//  Created by J-bb on 17/4/5.
//  Copyright © 2017年 com.yundian. All rights reserved.
//

import UIKit
import RealmSwift

class FlightModel: Object {
    
    var flightId = 0
    var flightNumber = ""
    var flightSpacePrice = 0.0
     var routeId = 0
     var routeName = ""
    var flightTime = ""

     var flightSpaceNumber = 0

}
class RequestFlightModel: TokenRequestModel {
    var routeId = 0
}


class RequestAirLineListModel: TokenRequestModel {
    
}
class BuyPositionModel: TokenRequestModel {
    var flightId = 0
    var flightNumber = ""
    var flightSpacePrice = 0.0
    var tradeNum = 0
    
}

class AddFlightModel: TokenRequestModel {
    var routeId = 0
    var flightNumber = ""
    var flightSpacePrice = 0.0
    var flightSpaceNumber = 0
    var phoneNum = ""
    var phoneCode = ""
    var codeToken = ""
    var flightTime = ""
    
}

class AirLineModel: Object {
    var routeId = 10001
    var routeName = "上海-东京"
    
}

class RequestHistroyModel: TokenModel {
    var recordPos = 0
}
class PoHistoryModel: Object {
    var tradeId = 0
    var tradeNo = ""
    var tradeGoodsId = 0
    var tradeGoodsName = ""
    var tradeGoodsNo = ""
    var tradeNum = 0
    var tradePrice = 0.0
    var tradeTotalPrice = 0.0
    var tradeStatus = 0
    var tradeTime:Int64 = 0
}

class HandlePositionModel: TokenModel {
    var tradeId = 0
    var handleType = 4
}
