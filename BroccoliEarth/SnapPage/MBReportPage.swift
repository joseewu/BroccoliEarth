//
//  MBReportPage.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/18.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class MBReportPage: UIViewController {
    private var showImage:UIImage? = nil
    @IBOutlet weak var reportImg: UIImageView!
    convenience init(with imag:UIImage?) {
        self.init()
        if let imag = imag {
            showImage = imag
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        reportImg.contentMode = .scaleAspectFit
        reportImg.clipsToBounds = true
        reportImg.image = showImage
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
}
