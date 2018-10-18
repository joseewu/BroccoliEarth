//
//  ButtonTableViewCell.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/18.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class ButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var confirmButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func didTap(_ sender: Any) {

    }
    private func renderUI() {

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
