//
//  LocationNodeExt.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/20.
//  Copyright © 2018 com.js. All rights reserved.
//

import Foundation
import ARCL
import MapKit
import CoreLocation
import SceneKit
extension LocationNode {
    static func render(locations: [CLLocationCoordinate2D]) -> [LocationNode] {
        let altitude = CLLocationDistance(exactly: 10)
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .ambient
        lightNode.light!.intensity = 25
        lightNode.light!.attenuationStartDistance = 100
        lightNode.light!.attenuationEndDistance = 100
        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
        lightNode.castsShadow = false
        lightNode.light!.categoryBitMask = 3

        let lightNode3 = SCNNode()
        lightNode3.light = SCNLight()
        lightNode3.light!.type = .omni
        lightNode3.light!.intensity = 100
        lightNode3.light!.attenuationStartDistance = 100
        lightNode3.light!.attenuationEndDistance = 100
        lightNode3.light!.castsShadow = true
        lightNode3.position = SCNVector3(x: -10, y: 10, z: -10)
        lightNode3.castsShadow = false
        lightNode3.light!.categoryBitMask = 3

        var nodes = [LocationNode]()

        for location in locations {
            let scene:SCNScene = SCNScene(named: "art.scnassets/Mosquito_Big.scn")!
            if let mosquitoNode = scene.rootNode.childNode(withName: "Mosquito", recursively: false) {
                let addLocation = CLLocation(coordinate: location, altitude: altitude ?? 10)
                let locationNode = LocationNode(location: addLocation)
                locationNode.addChildNode(mosquitoNode)
                nodes.append(locationNode)
            }
        }
        return nodes

    }
}
