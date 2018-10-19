//
//  LoginClient.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/19.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation
import FBSDKLoginKit
class LoginClient {
    init() {
        token = FBSDKAccessToken.current()?.tokenString
    }
    private var token:String?
    public var isLogin:Bool {
        return (token != nil) ? true:false
    }
    public var userToken:String? {
        return self.token
    }
    public func login() {

    }
}
