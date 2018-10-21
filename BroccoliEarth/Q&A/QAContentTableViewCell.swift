//
//  QAContentTableViewCell.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/21.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class QAContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        contentLabel.numberOfLines = 0
        backgroundColor = UIColor.white
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
