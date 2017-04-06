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
    var flightSpaceNumber = 0
}
class RequestFlightModel: TokenRequestModel {
    var routeId = 0
}

class BuyPositionModel: TokenRequestModel {
    var flightId = 0
    var flightNumber = ""
    var flightSpacePrice = 0.0
    var buyNum = 0
}

class AddFlightModel: TokenRequestModel {
    var routeId = 0
    var flightNumber = ""
    var flightSpacePrice = 0.0
    var flightSpaceNumber = 0
    var phoneNum = ""
    var phoneCode = ""
    var codeToken = ""
    
}
