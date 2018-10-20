//
//  MBPersonalPage.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/18.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import SDWebImage
enum MBPersonalPageCellType {
    case map
    case logout
    case question
    case myReports
    var title:String {
        switch self {
        case .map:
            return "Mosquito Map"
        case .logout:
            return "Logout"
        case .question:
            return "Mosquito Q&A"
        case .myReports:
            return "My reports"
        }
    }
}
class MBPersonalPage: BaseViewController {

    @IBOutlet weak var levelInfo: UILabel!
    @IBOutlet weak var levelBG: UIImageView!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var levelIcon: UIImageView!
    @IBOutlet weak var name: UILabel!

    private let user:User? = UserManager.shared.user
    private let personalPageCellType:[MBPersonalPageCellType] = [.map, .myReports,.question,.logout]
    override func viewDidLoad() {
        super.viewDidLoad()
        renderUi()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    private func renderUi() {
        levelInfo.text = "Lv.\(user?.level ?? 1)"
        levelBG.layer.cornerRadius = levelBG.frame.size.width/2
        levelBG.clipsToBounds = true
        levelBG.sd_setImage(with: user?.image) { (_, _, _, _) in

        }
        name.text = user?.name
        levelIcon.image = UIImage(named: "fly_swatter")?.withRenderingMode(.alwaysTemplate)
        tableView.register(UINib(nibName: "ButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "ButtonTableViewCell")
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension MBPersonalPage:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personalPageCellType.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let type:MBPersonalPageCellType = personalPageCellType[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ButtonTableViewCell", for: indexPath) as? ButtonTableViewCell
        cell?.confirmButton.setTitle(type.title, for: .normal)
        switch type {
        case .map:
            break
        case .logout:
            break
        case .question:
            break
        case .myReports:
            break
        }
        return cell!
    }
    
}
