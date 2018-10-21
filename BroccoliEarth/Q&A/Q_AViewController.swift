//
//  Q&AViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/20.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class Q_AViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "QACell")
        // Do any additional setup after loading the view.
    }
}
extension Q_AViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QACell", for: indexPath)
        return cell
    }


}
