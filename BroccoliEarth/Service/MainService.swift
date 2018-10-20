//
//  MainService.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/16.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
enum MBDomain {
    case reportImg(count:Int)
    case staticalInfo
    var name:String {
        switch self {
        case .reportImg(let count):
            return "https://s3-ap-northeast-1.amazonaws.com/nasahackerthon/nasa\(count).jpg"
        default:
            return ""
        }
    }
}
class MainService {
    init() {

    }
    public func getNumberOfReports(at:CLLocationCoordinate2D) {

    }
    public func sendMyLocation(at:CLLocationCoordinate2D){

    }
    public func sendReport(at:CLLocationCoordinate2D) {

    }
}

