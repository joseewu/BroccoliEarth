//
//  ParametersBuilder.swift
//  DramaTV
//
//  Created by joseewu on 2018/4/23.
//  Copyright © 2018年 com.chocolabs.dramacrazy. All rights reserved.
//

import Foundation
class ParametersBuilder {
    private var parameter: [String: Any]?
    init() {

    }
    func add(key: String, value: Any) -> ParametersBuilder {
        if parameter == nil {
            parameter = [String: Any]()
        }
        parameter?[key] = value
        return self
    }
    func create()->[String:Any] {
        let queries = parameter ?? [String: Any]()
        return queries
    }
}
