//
//  MBReportPage.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/18.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class MBReportPage: BaseViewController {
    public var showImage:UIImage? {
        didSet {
            loadViewIfNeeded()
            reportImg.image = showImage
        }
    }
    @IBOutlet weak var reportImg: UIImageView!
    @IBOutlet weak var reportBut: UIButton!
    @IBOutlet weak var typeSegment: UISegmentedControl!
    @IBOutlet weak var informationInput: UITextField!

    @IBAction func didTapReport(_ sender: Any) {
        //TODO: send report imformation

    }
    @IBAction func didSwitchType(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }

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
        reportBut.layer.cornerRadius = 7
        reportBut.clipsToBounds = true
        informationInput.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
}
extension MBReportPage:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        touchView.isHidden = true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        touchView.isHidden = false
    }
}
