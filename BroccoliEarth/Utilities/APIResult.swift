//
//  APIResult.swift
//  DramaTV
//
//  Created by joseewu on 2018/1/26.
//  Copyright © 2018年 com.chocolabs.dramacrazy. All rights reserved.
//

import Foundation
// MARK: Error and Results handling

public class ApiError: Error, LocalizedError {
    let statusCode: Int
    let data: Any?

    init(statusCode: Int, data: Any?) {
        self.statusCode = statusCode
        self.data = data

        if statusCode == 401 {
            NotificationCenter.default.post(name: NSNotification.Name("Defines.NOTIFICATION_FORCE_LOGOUT"), object: nil)
        }
    }

    public var localizedHudDescription: String {
        switch data {
        case let jobjArr as [String: [String]]:
            var msgs = [String]()
            for jobj in jobjArr {
                msgs.append("\(jobj.value.joined(separator: ", "))")
            }
            return msgs.joined(separator: "\n")
        case let jObj as [String: Any]:
            if let message = jObj["message"] as? String {
                return message
            }
            return ""
        default:
            return ""
        }
    }
}
public enum RuntimeError: Error, LocalizedError {
    case Cast
    case NoResponse
    case NoData
    case Custom(reason: String)
    case Whatever

    public var errorDescription: String? {
        switch self {
        case .Cast:
            return "Cast Error"
        case .NoResponse:
            return "No Response Error"
        case .NoData:
            return "No Data Error"
        case .Custom(let reason):
            return "Custom Error: \(reason)"
        default:
            return "not define yet."
        }
    }
}
// MARK: Genric Result
public enum Result<T> {
    case Success(T?)
    case Failure(Error)
    var isSuccsee: Bool {
        switch self {
        case .Success:
            return true
        case .Failure:
            return false
        }
    }
    var isFailure: Bool {
        return !isSuccsee
    }
    var value: T? {
        switch self {
        case .Success(let result):
            return result
        case .Failure:
            return nil
        }
    }
    var error: Error? {
        switch self {
        case .Success:
            return nil
        case .Failure(let error):
            return error
        }
    }
}
