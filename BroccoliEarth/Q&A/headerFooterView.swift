//
//  headerFooterView.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/21.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit

class headerFooterView: UITableViewHeaderFooterView {
    let titleLabel:UILabel = UILabel()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        renderUi()
    }
    private func renderUi() {

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
