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
//    static func create(polyline: MKPolyline, altitude: CLLocationDistance)  -> [LocationNode] {
//        let points = polyline.points()
//
//        let lightNode = SCNNode()
//        lightNode.light = SCNLight()
//        lightNode.light!.type = .ambient
//        lightNode.light!.intensity = 25
//        lightNode.light!.attenuationStartDistance = 100
//        lightNode.light!.attenuationEndDistance = 100
//        lightNode.position = SCNVector3(x: 0, y: 10, z: 0)
//        lightNode.castsShadow = false
//        lightNode.light!.categoryBitMask = 3
//
//        let lightNode3 = SCNNode()
//        lightNode3.light = SCNLight()
//        lightNode3.light!.type = .omni
//        lightNode3.light!.intensity = 100
//        lightNode3.light!.attenuationStartDistance = 100
//        lightNode3.light!.attenuationEndDistance = 100
//        lightNode3.light!.castsShadow = true
//        lightNode3.position = SCNVector3(x: -10, y: 10, z: -10)
//        lightNode3.castsShadow = false
//        lightNode3.light!.categoryBitMask = 3
//
//        var nodes = [LocationNode]()
//
//        for i in 0..<polyline.pointCount - 1 {
//            let currentPoint = points[i]
//            let currentCoordinate = MKMapPoint
//            let currentLocation = CLLocation(coordinate: currentCoordinate, altitude: altitude)
//
//            let nextPoint = points[i + 1]
//            let nextCoordinate = MKCoordinateForMapPoint(nextPoint)
//            let nextLocation = CLLocation(coordinate: nextCoordinate, altitude: altitude)
//
//            let distance = currentLocation.distance(from: nextLocation)
//
//            let box = SCNBox(width: 1, height: 0.2, length: CGFloat(distance), chamferRadius: 0)
//            box.firstMaterial?.diffuse.contents =  UIColor(hue: 0.589, saturation: 0.98, brightness: 1.0, alpha: 1)
//
//            let bearing = 0 - bearingBetweenLocations(point1: currentLocation, point2: nextLocation)
//
//            let boxNode = SCNNode(geometry: box)
//            boxNode.pivot = SCNMatrix4MakeTranslation(0, 0, 0.5 * Float(distance))
//            boxNode.eulerAngles.y = Float(bearing).degreesToRadians
//            boxNode.categoryBitMask = 3
//            boxNode.addChildNode(lightNode)
//            boxNode.addChildNode(lightNode3)
//
//            let locationNode = LocationNode(location: currentLocation)
//            locationNode.addChildNode(boxNode)
//            nodes.append(locationNode)
//        }
//        return nodes
//    }
}
