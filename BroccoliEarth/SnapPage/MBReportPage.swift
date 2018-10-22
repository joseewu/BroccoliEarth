//
//  MBReportPage.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/18.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import CoreLocation
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
    private let client:MainService = MainService()
    private let locationType:[String] = ["室外","室內"]
    var location:CLLocationCoordinate2D?
    @IBAction func didTapReport(_ sender: Any) {
        //TODO: send report imformation
        guard let currentLocation = location else { return }
        let coordinate = CLLocationCoordinate2D(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        let selectedType:String = locationType[typeSegment.selectedSegmentIndex]
        let report = ShowReport.init(img: showImage, location: coordinate, comment: informationInput.text, type: selectedType)
        client.sendReportImage(report) { [weak self] (isFinished) in
            if isFinished {
               self?.showAlert()
            } else {
                self?.showError()
            }
        }

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
    private func showAlert() {
        let alertController = UIAlertController(title: "回報成功", message: "經驗值+++", preferredStyle: .alert)
        let action = UIAlertAction(title: "取得經驗值", style: .default) { [weak self] _ in
            UserManager.shared.upgrade(1)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                self?.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    private func showError() {
        let alertController = UIAlertController(title: "回報失敗", message: "請再次嘗試", preferredStyle: .alert)
        let action = UIAlertAction(title: "我知道了", style: .cancel) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
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
