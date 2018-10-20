//
//  PhotosPreviewPage.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/18.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import SDWebImage

class PhotosPreviewPage: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ReportImageCell", bundle: nil), forCellReuseIdentifier: "ReportImageCell")
        tableView.estimatedRowHeight = 100
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension PhotosPreviewPage:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReportImageCell", for: indexPath) as? ReportImageCell
        let count = indexPath.row + 1
        guard let imgURL = URL(string: MBDomain.reportImg(count: count).name) else {return cell!}
        cell?.reportImg?.sd_setImage(with: imgURL, completed: { (_, _, _, _) in
            
        })
        return cell!
    }


}
