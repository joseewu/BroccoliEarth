//
//  LoginClient.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/19.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Alamofire

class LoginClient {

    init() {
        token = FBSDKAccessToken.current()?.tokenString
    }
    private var token:String?
    private var fbUserId:String?
    public var userToken:String? {
        return self.token
    }
    public func login(_ completionHadler:@escaping (_ result:FBSDKProfile?, _ user:Int?)->Void) {
        token = FBSDKAccessToken.current()?.tokenString
        fbUserId = FBSDKAccessToken.current()?.userID
        FBSDKProfile.loadCurrentProfile { (profile, error) in
            self.loginServer(profile, { (userId) in
                completionHadler(profile, userId)
            })
        }
    }
    private func loginServer(_ profile:FBSDKProfile?, _ completionHandler:@escaping ((_ userId:Int?) -> Void)) {
        /*
 ‘name’ (string)
 ‘email’ (string)
 ‘provider_id’ (int)
 ‘provider_token’ (string)
 */
        guard let token = token, let fbUserId = fbUserId, let userIdInt = Int(fbUserId) else {

            completionHandler(nil)
            return
        }
        let parameters:[String:Any] = ["name":profile?.name ?? "","email":"","provider_id":userIdInt,"provider_token":token]
        Alamofire.request("https://api.mosquitalert.app/api/login/facebook/callback", method: .post, parameters: parameters).responseJSON { (result) in
            if let error = result.result.error {
                print(error.localizedDescription)
            } else {
                if let data = result.result.value as? [String:Any] {
                    guard let pureData = data["data"] as? [String:Any] else {
                        completionHandler(nil)
                        return}
                    guard let userId = pureData["id"] as? Int else {
                        completionHandler(nil)
                        return}
                    completionHandler(userId)
                }else {
                    completionHandler(nil)
                }
            }
        }
    }
}
