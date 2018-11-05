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
    case sendReportImg
    case sendReport
    case locationStatus
    var name:String {
        switch self {
        case .reportImg(let imageName):
            return "https://s3.ap-northeast-1.amazonaws.com/mosquitalert/\(imageName)"
        case .reports:
            return "https://api.mosquitalert.app/api/getAllMarkers"
        case .sendReportImg:
            return "https://api.mosquitalert.app/api/images"
        case .sendReport:
            return "https://api.mosquitalert.app/api/reports"
        case .locationStatus:
            return "http://54.65.61.167/predictcoords"
        default:
            return ""
        }
    }
}
enum MBLocationStatus {
    case good
    case soso
    case aware
    case dangerous
    var warningTitle:String {
        switch self {
        case .aware:
            return "注意區域"
        case .good:
            return "安全區域"
        case .soso:
            return "輕微區域"
        case .dangerous:
            return "危險區域"
        }
    }
    init?(probability: CGFloat) {
        switch true {
        case (probability > 0 && probability < 0.25): self = .good
        case probability >= 0.25 && probability < 0.5: self = .soso
        case probability >= 0.5  && probability < 0.75: self = .aware
        case probability >= 0.75: self = .dangerous
        default: self = .good
        }
    }
}
class MainService {
    init() {

    }
    /*
     ‘file’ (file)
     'userId' (int)
     'latitude' (float)
     'longitude' (float)
     'type' (string)
     'description' (string)

 */
    public func sendBitReport(_ completionHandler:@escaping ((_ isFinished:Bool) -> Void)) {
        guard let latitude = UserManager.shared.location?.latitude, let longitude = UserManager.shared.location?.longitude, let userId = UserManager.shared.user?.userId  else {
            completionHandler(false)
            return
        }
        let parameters:[String:Any] = ["latitude":latitude,"longitude":longitude, "userId": userId]
        Alamofire.request(MBDomain.sendReport.name, method: .post, parameters: parameters).responseJSON { (result) in
            if let error = result.result.error {
                print(error.localizedDescription)
                completionHandler(false)
            } else {
                if let data = result.result.value as? [String:Any] {
                    if let status = data["status"] as? String, status == "success" {
                        completionHandler(true)
                    } else {
                        completionHandler(false)
                    }
                } else {
                    completionHandler(false)
                }
            }
        }
    }
    public func getCurrentLocationAlarm(_ completionHandler:@escaping ((_ status:MBLocationStatus?) -> Void)) {
        guard let latitude = UserManager.shared.location?.latitude, let longitude = UserManager.shared.location?.longitude else {
            completionHandler(nil)
            return
        }
        let parameters:[String:Any] = ["lat":latitude,"lon":longitude]
        Alamofire.request(MBDomain.locationStatus.name, method: .get, parameters: parameters).responseJSON { (result) in
            if let error = result.result.error {
                print(error.localizedDescription)
                completionHandler(nil)
            } else {
                if let data = result.result.value as? [String:Any] {
                    if let probibility = data["probability"] as? CGFloat {
                        let status = MBLocationStatus.init(probability: probibility)
                        completionHandler(status)
                    } else {
                        completionHandler(nil)
                    }
                } else {
                    completionHandler(nil)
                }
            }
        }
    }
    public func sendReportImage(_ report:ShowReport, completionHandler:@escaping ((_ isFinished:Bool) -> Void)) {
        guard let image = report.img else {return}
        let imgData = image.jpegData(compressionQuality: 0.2)!
        let parameters:[String:Any] = ["file": imgData, "userId":1, "latitude":Float(report.location.coordinate.latitude), "longitude":Float(report.location.coordinate.longitude),"type":"", "description":report.comment ?? ""]
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imgData, withName: "file",fileName: "report.jpg", mimeType: "image/jpg")
            for (key, value) in parameters {
                switch value {
                case let number as Int:
                    multipartFormData.append(String(number).data(using: .utf8)!, withName: key)
                case let number as Float:
                    multipartFormData.append(String(number).data(using: .utf8)!, withName: key)
                case let str as String:
                    multipartFormData.append(str.data(using: .utf8)!, withName: key)
                case let url as URL:
                    guard url.isFileURL else {
                        continue}
                    multipartFormData.append(url, withName: key)
                case let condition as Bool:
                    multipartFormData.append(condition.description.data(using: .utf8)!, withName: key)
                default:
                    continue
                }
            }
        },
                         to:MBDomain.sendReportImg.name)
        { (result) in
            switch result {
            case .success(let upload, _, _):

                upload.uploadProgress(closure: { (progress) in
                    print("Upload Progress: \(progress.fractionCompleted)")
                })

                upload.responseJSON { response in
                    print(response.result.value)
                    completionHandler(true)
                }
            case .failure(let encodingError):
                print(encodingError)
                completionHandler(false)
            }
        }
    }
    public func sendMyLocation(at:CLLocationCoordinate2D, completionHandler:@escaping ((ArrayDataTransform<MBReport>?) -> Void)){
        let parameters = ["latitude":Double(at.latitude),"longitude":Double(at.longitude)]
        Alamofire.request(MBDomain.reports.name, method: .post, parameters: parameters).responseData(completionHandler: { (data) in
            guard let pureData = data.data else {
                completionHandler(nil)
                return}
            do {
                let decoder = JSONDecoder.init()
                let resutlt = try decoder.decode(ArrayDataTransform<MBReport>.self, from: pureData)
                completionHandler(resutlt)
            } catch {
                completionHandler(nil)
            }
        })
    }
    public func getImg() {
        return
    }
    public func sendReport(at:CLLocationCoordinate2D) {

    }
}

