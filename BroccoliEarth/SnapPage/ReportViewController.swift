//
//  ReportViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/16.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import CoreLocation
class ReportViewController: BaseViewController {
    @IBOutlet weak var reportBut: UIButton!
    private let client:MainService = MainService()
    private var userLocation:CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        reportBut.layer.cornerRadius = 4
        reportBut.clipsToBounds = true
    }
    @IBAction func reportBitBut(_ sender: Any) {
        client.sendBitReport { [weak self] (isFinished) in
            if isFinished {
                self?.showAlert()
            } else {
                self?.showError()
            }
        }
    }
    private func showAlert() {
        let alertController = UIAlertController(title: "回報成功", message: "經驗值+++", preferredStyle: .alert)
        let action = UIAlertAction(title: "取得經驗值", style: .default) { [weak self] _ in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
                self?.navigationController?.popViewController(animated: true)
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
