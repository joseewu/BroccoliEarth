//
//  MBLocation.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/16.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation


struct MBLocation:Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case latitude
        case longitude
        case isOverRated
        case reportNumber
    }
    let name:String?
    let latitude:Double?
    let longitude:Double?
    let isOverRated:Bool?
    let reportNumber:Double?
}
extension MBLocation {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        isOverRated = try container.decode(Bool.self, forKey: .isOverRated)
        reportNumber = try container.decode(Double.self, forKey: .reportNumber)
    }
}

