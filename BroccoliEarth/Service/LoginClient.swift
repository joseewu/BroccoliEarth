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
    private var userId:String?
    public var userToken:String? {
        return self.token
    }
    public func login(_ completionHadler:@escaping (_ result:FBSDKProfile?)->Void) {
        token = FBSDKAccessToken.current()?.tokenString
        userId = FBSDKAccessToken.current()?.userID
        FBSDKProfile.loadCurrentProfile { (profile, error) in
           completionHadler(profile)
        }
    }
    private func loginServer(_ completionHandler:@escaping ((_ isFinished:Bool) -> Void)) {
        /*
 ‘name’ (string)
 ‘email’ (string)
 ‘provider_id’ (int)
 ‘provider_token’ (string)
 */
        guard let token = token, let userId = userId, let userIdInt = Int(userId) else {

            completionHandler(false)
            return
        }
        let parameters:[String:Any] = ["name":Float(25.025652),"email":Float(121.527475),"provider_id":userIdInt,"provider_token":token]
        Alamofire.request("https://api.mosquitalert.app/api/login/facebook/callback", method: .post, parameters: parameters).responseJSON { (result) in
            if let error = result.result.error {
                print(error.localizedDescription)
            } else {
                if let data = result.result.value as? [String:Any] {
                    print(data)
                }
            }
        }
    }
}
