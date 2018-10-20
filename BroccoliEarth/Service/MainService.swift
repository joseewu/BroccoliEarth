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
    case reportImg(imageName:String)
    case staticalInfo
    case reports
    var name:String {
        switch self {
        case .reportImg(let imageName):
            return "https://s3.ap-northeast-1.amazonaws.com/mosquitalert/\(imageName)"
        case .reports:
            return "https://api.mosquitalert.app/api/getAllMarkers"
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
    public func sendMyLocation(at:CLLocationCoordinate2D, completionHandler:@escaping (([MBReport]?) -> Void)){
        let parameters = ["latitude":Double(at.latitude),"longitude":Double(at.longitude)]
        Alamofire.request(MBDomain.reports.name, method: .post, parameters: parameters).responseData(completionHandler: { (data) in
            guard let pureData = data.data else {
                completionHandler(nil)
                return}
            do {
                let decoder = JSONDecoder.init()
                let resutlt = try decoder.decode([MBReport].self, from: pureData)
                completionHandler(resutlt)
            } catch {
                completionHandler(nil)
            }
        })
    }
    public func sendReport(at:CLLocationCoordinate2D) {

    }
}

