//
//  Q&AViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/20.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

struct QACellSection {
    let sectionTitle:String
    let cellContent:String
}
class Q_AViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private var data:[QACellSection] = [QACellSection]() {
        didSet {
            tableView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clear
        tableView.register(UINib(nibName: "QAContentTableViewCell", bundle: nil), forCellReuseIdentifier: "QAContentTableViewCell")
        self.data = prepareData()

        // Do any additional setup after loading the view.
    }
    private func prepareData() -> [QACellSection] {
        var qaData = [QACellSection]()
        let q1 = QACellSection(sectionTitle: "登革熱會人傳人嗎？", cellContent: "不會。登革熱主要是帶有病毒的病媒蚊叮咬人，病毒經由病媒蚊的唾液傳入人體，不會人直接傳人，也不會透過空氣傳染或接觸傳染。台灣主要的病媒蚊是埃及斑蚊與白線斑蚊，牠們的共同特徵是腳上有白斑。")
        qaData.append(q1)
        let q2 = QACellSection(sectionTitle: "常見孳生源有哪些?", cellContent: "病媒蚊孳生的場所為家屋內外或家屋附近盛水之各種容器，比如水缸、水甕、鐵桶、木桶、塑膠桶、水泥槽、廢輪胎、花瓶、花盤、空罐、破瓶等人工容器。及樹洞、竹洞、屋簷、排水溝等。")
        qaData.append(q2)
        let q3 = QACellSection(sectionTitle: "疑似得登革熱，感覺不適時，我可以做什麼?", cellContent: "當您感覺有疑似登革熱症狀，請至鄰近快篩院所檢驗，並多補充水分、靜心休養。")
        qaData.append(q3)
        let q4 = QACellSection(sectionTitle: "登革熱病媒蚊的生活習性為何？", cellContent: "埃及斑蚊多棲息在室內，喜歡陰暗的角落，大都分在嘉義布袋以南各縣市。白線斑蚊喜歡在室外，活動時間為白天，主要分在於全島平地及高度1500以下山區。")
        qaData.append(q4)
        return qaData
    }
}
extension Q_AViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let qa = data[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "QAContentTableViewCell", for: indexPath) as? QAContentTableViewCell
        cell?.contentLabel.text = qa.cellContent
        return cell!
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let qa = data[section]
        let headerView = UIView()
        headerView.backgroundColor = UIColor("#2d4868")
        let titleLabel = UILabel()
        titleLabel.text = qa.sectionTitle
        titleLabel.textColor = UIColor.white
        titleLabel.frame.origin.x = self.view.frame.origin.x + 15
        titleLabel.sizeToFit()
        headerView.addSubview(titleLabel)
        return headerView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
