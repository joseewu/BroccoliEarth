//
//  UserManager.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/19.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation

class UserManager {
    static var shared: UserManager = {
        let client = LoginClient()
        let manager = UserManager(client: client)
        return manager
    }()
    private init(client:LoginClient) {
        loginClient = client
    }
    private var loginClient:LoginClient
    public func getUserToken() -> String {
        if let tokenStr = loginClient.userToken {
            return tokenStr
        }
        return ""
    }
}
