//
//  MockLoactions.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/31.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation

struct MockLoactions {
    let locations:[MBLocation]
    init() {
        var temp:[MBLocation] = [MBLocation]()
        let bank:MBLocation = MBLocation(25.030606, 121.548249)
        let myCurrent:MBLocation = MBLocation(25.030682353988745, 121.54891576258588)
        let store:MBLocation = MBLocation(25.031106, 121.548279)
        let chineseBank:MBLocation = MBLocation(25.029851, 121.548496)
        let meatStore:MBLocation = MBLocation(25.030606, 121.550185)
        temp.append(bank)
        temp.append(myCurrent)
        temp.append(store)
        temp.append(chineseBank)
        temp.append(meatStore)
        self.locations = temp
    }
}
