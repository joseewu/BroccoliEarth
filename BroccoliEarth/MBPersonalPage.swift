//
//  MBPersonalPage.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/18.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class MBPersonalPage: UIViewController {

    @IBOutlet weak var levelBG: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUi()
        // Do any additional setup after loading the view.
    }
    private func renderUi() {
        levelBG.image = UIImage(named: "level")?.withRenderingMode(.alwaysTemplate)
        levelBG.tintColor = UIColor.yellow
        
    }
}
