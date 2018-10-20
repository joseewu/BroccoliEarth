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
        default:
            return ""
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
    public func sendBitReport(_ report:ShowReport, completionHandler:@escaping ((_ isFinished:Bool) -> Void)) {
        let parameters = ["latitude":Float(report.location.latitude),"longitude":Float(report.location.longitude)]
        Alamofire.request(MBDomain.reports.name, method: .post, parameters: parameters).responseJSON { (result) in
            if let error = result.result.error {
                print(error.localizedDescription)
            } else {
                if let data = result.result.value as? [String:Any] {
                    print(data)
                }
            }
        }
    }
    public func sendReportImage(_ report:ShowReport, completionHandler:@escaping ((_ isFinished:Bool) -> Void)) {
        guard let image = report.img else {return}
        let imgData = image.jpegData(compressionQuality: 0.2)!
        let parameters:[String:Any] = ["file": imgData, "userId":1, "latitude":Float(report.location.latitude), "longitude":Float(report.location.longitude),"type":"", "description":"好不爽"]
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
                         to:MBDomain.sendReport.name)
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
    public func getNumberOfReports(at:CLLocationCoordinate2D) {

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

