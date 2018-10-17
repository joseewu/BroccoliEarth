//
//  MBLoginViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/16.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MBLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        renderUi()
        // Do any additional setup after loading the view.
    }

    private func renderUi() {
        let loginButton = FBSDKLoginButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        loginButton.center = view.center
        loginButton.readPermissions = ["public_profile","email"]
        loginButton.delegate = self
        view.addSubview(loginButton)
    }

}
extension MBLoginViewController:FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("user : \(FBSDKAccessToken.current()?.tokenString ?? "no")")
    }
}
