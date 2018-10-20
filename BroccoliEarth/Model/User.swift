//
//  User.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/19.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation

struct User:Codable {
    private enum CodingKeys: String, CodingKey {
        case name
        case email
        case image
        case level
    }
    let name:String?
    let email:String?
    let image:URL?
    let level:Int?
    init(name:String?,email:String?,image:URL?, level:Int?) {
        self.email = email
        self.name = name
        self.image = image
        self.level = level
    }
}
extension User {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try? container.decode(String.self, forKey: .name)
        email = try? container.decode(String.self, forKey: .email)
        image = try? container.decode(URL.self, forKey: .image)
        level = try? container.decode(Int.self, forKey: .level)
    }
}
