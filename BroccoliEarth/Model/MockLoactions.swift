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
        let myCurrent:MBLocation = MBLocation(25.06495705924448, 121.53751752805083)
        let store:MBLocation = MBLocation(25.031106, 121.548279)
        let chineseBank:MBLocation = MBLocation(25.029851, 121.548496)
        let meatStore:MBLocation = MBLocation(25.030606, 121.550185)
        let school:MBLocation = MBLocation(25.033788, 121.540417)
        let gym:MBLocation = MBLocation(25.033763, 121.539446)
        let park:MBLocation = MBLocation(25.062741, 121.540076)
        temp.append(bank)
        temp.append(myCurrent)
        temp.append(store)
        temp.append(chineseBank)
        temp.append(meatStore)
        temp.append(school)
        temp.append(gym)
        temp.append(park)
        self.locations = temp
    }
}
