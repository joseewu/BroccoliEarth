//
//  UserManager.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/19.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import CoreLocation

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
    var location:CLLocationCoordinate2D?
    public var user:User? {
        didSet {
            if let user = user {
                update?(user)
            }
        }
    }
    public var userlevel:Float? {
        let level = UserDefaults.standard.integer(forKey: "userLevel")
        let new = Float(level)/50

        return new
    }
    func upgrade(_ point:Int) {
        let oldValue = UserDefaults.standard.integer(forKey: "userLevel")
        let newValue = oldValue + point
        UserDefaults.standard.set(newValue, forKey: "userLevel")
        UserDefaults.standard.synchronize()
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
        loginClient.login { [weak self] (profile, userId)  in
            let user = User(name: profile?.name, email: profile?.middleName, image: profile?.imageURL(for: FBSDKProfilePictureMode.square, size: CGSize(width: 100, height: 100)), level: 1, userId:userId)
            self?.user = user
            UserDefaults.standard.set(user.userId, forKey: "userId")
            UserDefaults.standard.synchronize()
            completionHandler(user)
        }
    }
}
