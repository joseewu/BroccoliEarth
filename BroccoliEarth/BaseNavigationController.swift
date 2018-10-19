//
//  BaseNavigationController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/19.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    func showNavigationBar() {
        self.navigationBar.isHidden = false
    }
    func hideNavigationBar() {
        self.navigationBar.isHidden = true
    }
}
