//
//  MBLoginViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/16.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class MBLoginViewController: BaseViewController {

    @IBOutlet weak var loginButton: FBSDKLoginButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUi()
        // Do any additional setup after loading the view.
    }

    private func renderUi() {
        loginButton.delegate = self
    }

}
extension MBLoginViewController:FBSDKLoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {

    }
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        UserManager.shared.login()
    }
}
