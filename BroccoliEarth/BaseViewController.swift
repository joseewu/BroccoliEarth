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
    internal let touchView:UIView = UIView()
    private let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer()
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUi()
    }

    private func renderUi() {
        view.backgroundColor = mainColorBlue
        touchView.frame = view.bounds
        touchView.backgroundColor = UIColor.clear
        view.addSubview(touchView)
        touchView.isHidden = true
        tapGesture.addTarget(self, action: #selector(didTapTouchView))
        touchView.addGestureRecognizer(tapGesture)
    }
    @objc func didTapTouchView() {
        view.endEditing(true)
    }
}
