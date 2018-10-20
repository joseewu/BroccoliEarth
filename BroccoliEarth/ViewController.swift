//
//  ViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/12.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import ARCL
import CoreLocation
import Floaty
import SDWebImage

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var floatButton:Floaty = Floaty(size: 65)
    var sceneLocationView = SceneLocationView()
    var currentLocation:CLLocationCoordinate2D?
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var profile: UIImageView!
    @IBOutlet weak var addScene: UIButton!
    var testLocation:CLLocationCoordinate2D?
    private let client:MainService = MainService()

    private let userManager:UserManager = UserManager.shared
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
    }

    @IBAction func addNodeRandomlu(_ sender: Any) {
        guard let currentLocation = currentLocation else {return}
        let scene:SCNScene = SCNScene(named: "art.scnassets/Mosquito_Color.scn")!
        let mosquitoNode = scene.rootNode.childNode(withName: "Mosquito", recursively: false)!
        mosquitoNode.rotation = SCNVector4Make(0, 1, 0, .pi / 10)
        mosquitoNode.scale = SCNVector3Make(0.1, 0.1, 0.1)
    sceneLocationView.scene.rootNode.addChildNode(mosquitoNode)
        print("count: \(sceneLocationView.scene.rootNode.childNodes.count)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        // Create a new scene
        sceneLocationView.locationDelegate = self
        userManager.update = { [weak self] user in
            self?.nameLabel.text = user.name
            self?.progressView.progress = 0.5
            self?.profile.sd_setImage(with: user.image) { (image, error, cache, url) in
                print(error?.localizedDescription ?? "an error occur")
            }
        }
        let scene:SCNScene = SCNScene(named: "art.scnassets/Mosquito_Color.scn")!
        // Set the scene to the view
        sceneView.scene = scene
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        addScene.isHidden = true
        view.addSubview(addScene)
        userManager.login()
        renderUi()
        var locationsss:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        let coordinate1 = transform(CLLocationDegrees(exactly: Float(25.0265)), CLLocationDegrees(exactly: Float(121.526454)))
        locationsss.append(coordinate1)
        renderLocationNode(locationsss)

        //25.026516, 121.526454

    }
    private func transform(_ lati:CLLocationDegrees?, _ long:CLLocationDegrees?) -> CLLocationCoordinate2D {
        guard let lati = lati, let long = long else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        return CLLocationCoordinate2D(latitude: lati, longitude: long)
    }
    private func renderLocationNode(_ locations:[CLLocationCoordinate2D]) {
        let locationNode = LocationNode.render(locations: locations)
        for node in locationNode {
            //sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: node)
            sceneLocationView.updatePositionAndScaleOfLocationNode(locationNode: node)
        }
    }
    private func renderUi() {
        floatButton.buttonColor = UIColor("#c44056")
        floatButton.addItem(icon: UIImage(named: "spaceman_bk")!) { [weak self] (item) in
            self?.showPersonalPage()
        }
        floatButton.addItem(icon: UIImage(named: "icon_camera")?.withRenderingMode(.alwaysTemplate)) { [weak self] (item) in
            self?.showReportPage()
        }
        floatButton.addItem(icon: UIImage(named: "mosquito")!) { [weak self] (item) in
            self?.showReportBitPage()
        }
        view.addSubview(floatButton)
        profile.layer.cornerRadius = profile.frame.size.width/2
        profile.clipsToBounds = true
        profile.contentMode = .scaleAspectFill
    }
    private func showReportBitPage() {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc:ReportViewController = storyboard.instantiateViewController(withIdentifier: "ReportViewController") as? ReportViewController {
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    private func showReportPage() {
        let storyboard:UIStoryboard = UIStoryboard(name: "ReportPages", bundle: nil)
        if let vc:BaseNavigationController = storyboard.instantiateViewController(withIdentifier: "baseNavigation") as? BaseNavigationController {
            present(vc, animated: true, completion: nil)
        }
    }
    private func showPersonalPage() {
        let vc:MBPersonalPage = MBPersonalPage()
        navigationController?.pushViewController(vc, animated: true)
    }
    private func getMyLocationReport() {
        guard let currentLocation = currentLocation else {
            return
        }
        client.sendMyLocation(at: currentLocation) { (result) in
            guard let reports = result else {return}
            print(reports)
        }
    }
    //private func transform
    internal func addNode(at location:CLLocationCoordinate2D) {
        if currentLocation != nil {
            return
        }
        currentLocation = location
//        let coordinate = CLLocationCoordinate2D(latitude: location.latitude + 0.02, longitude: location.longitude + 0.00001)
//        let location = CLLocation(coordinate: coordinate, altitude: 10)
//        let image = UIImage(named: "pin")!
//
//        let annotationNode = LocationAnnotationNode(location: location, image: image)
//        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        sceneLocationView.frame = view.bounds
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
extension ViewController:SceneLocationViewDelegate {
    func sceneLocationViewDidAddSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        if let current = sceneLocationView.currentLocation()?.coordinate {
            addNode(at: current)
            getMyLocationReport()
        }
    }
    
    func sceneLocationViewDidRemoveSceneLocationEstimate(sceneLocationView: SceneLocationView, position: SCNVector3, location: CLLocation) {
        
    }
    
    func sceneLocationViewDidConfirmLocationOfNode(sceneLocationView: SceneLocationView, node: LocationNode) {
        
    }
    
    func sceneLocationViewDidSetupSceneNode(sceneLocationView: SceneLocationView, sceneNode: SCNNode) {
        
    }
    
    func sceneLocationViewDidUpdateLocationAndScaleOfLocationNode(sceneLocationView: SceneLocationView, locationNode: LocationNode) {
        
    }
    
    
}
extension  CGFloat{
    var degreesToRadians:CGFloat { return CGFloat(self) * .pi/180}

}

