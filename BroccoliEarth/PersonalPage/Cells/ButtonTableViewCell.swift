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
        renderUI()
        // Initialization code
    }
    @IBAction func didTap(_ sender: Any) {

    }
    private func renderUI() {
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        confirmButton.layer.cornerRadius = 4
        confirmButton.clipsToBounds = true
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
