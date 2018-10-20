//
//  ReportViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/16.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class ReportViewController: BaseViewController {

    @IBOutlet weak var reportBut: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        reportBut.layer.cornerRadius = 4
        reportBut.clipsToBounds = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}
