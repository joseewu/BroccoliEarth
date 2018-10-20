//
//  ReportImageCell.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/20.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class ReportImageCell: UITableViewCell {

    @IBOutlet weak var reportImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        reportImg.contentMode = .scaleAspectFill
        reportImg.clipsToBounds = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
