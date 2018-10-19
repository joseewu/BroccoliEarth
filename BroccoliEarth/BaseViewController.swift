//
//  BaseViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/19.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    private var mainColorBlue:UIColor = UIColor("#2d4868")
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUi()
    }
    
    private func renderUi() {
        view.backgroundColor = mainColorBlue
    }
}
