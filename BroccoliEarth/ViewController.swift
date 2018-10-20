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
        view.addSubview(addScene)
        userManager.login()
        renderUi()
    }
    private func renderUi() {
        floatButton.buttonColor = UIColor("#c44056")
        floatButton.addItem(icon: UIImage(named: "spaceman_bk")!) { [weak self] (item) in
            self?.showPersonalPage()
        }
        floatButton.addItem(icon: UIImage(named: "mosquito")!) { [weak self] (item) in
            self?.showReportPage()
        }
        view.addSubview(floatButton)
        profile.layer.cornerRadius = profile.frame.size.width/2
        profile.clipsToBounds = true
        profile.contentMode = .scaleAspectFill
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
    internal func addNode(at location:CLLocationCoordinate2D) {
        if currentLocation != nil {
            return
        }
        currentLocation = location
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude + 0.02, longitude: location.longitude + 0.00001)
        let location = CLLocation(coordinate: coordinate, altitude: 300)
        let image = UIImage(named: "pin")!

        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
        
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
            //addNode(at: current)
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

    /// Converts Degrees To Radians
    var degreesToRadians:CGFloat { return CGFloat(self) * .pi/180}

}
