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

            }
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    private func showAlert() {
        let alertController = UIAlertController(title: "回報成功", message: "經驗值+++", preferredStyle: .alert)
        let action = UIAlertAction(title: "取得經驗值", style: .default) { [weak self] _ in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    private func showError() {
        let alertController = UIAlertController(title: "回報成功", message: "經驗值+++", preferredStyle: .alert)
        let action = UIAlertAction(title: "取得經驗值", style: .default) { [weak self] _ in
            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
}
