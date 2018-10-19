//
//  UserManager.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/19.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation
import FBSDKLoginKit

class UserManager {
    static var shared: UserManager = {
        let client = LoginClient()
        let manager = UserManager(client: client)
        if manager.isUserLogin {
            manager.getUserProfile({ _ in

            })
        }
        return manager
    }()
    private init(client:LoginClient) {
        loginClient = client
    }
    private var loginClient:LoginClient
    public var user:User? {
        didSet {
            if let user = user {
                update?(user)
            }
        }
    }
    public var update:((User) -> Void)?
    private var token:String? {
        return FBSDKAccessToken.current()?.tokenString
    }
    public var isUserLogin:Bool {
        return (token != nil) ? true:false
    }
    public func login() {
        getUserProfile { _ in

        }
    }
    public func logout() {
        FBSDKLoginManager.init().logOut()
        FBSDKAccessToken.setCurrent(nil)
    }
    private func getUserProfile(_ completionHandler:@escaping (User?)->Void){
        loginClient.login { [weak self] (result) in
            let user = User(name: result?.name, email: result?.middleName, image: result?.imageURL(for: FBSDKProfilePictureMode.square, size: CGSize(width: 100, height: 100)))
            self?.user = user
            completionHandler(user)
        }
    }
}
