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

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var floatButton:Floaty = Floaty(size: 60)
    var sceneLocationView = SceneLocationView()
    var currentLocation:CLLocationCoordinate2D?
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        let scene = SCNScene(named: "art.scnassets/rose.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        renderUi()
    }
    private func renderUi() {
        floatButton.addItem(icon: UIImage(named: "photoPicker")!) { [weak self] (item) in
            self?.showReportPage()
        }
        floatButton.addItem(icon: UIImage(named: "photoPicker")!) { [weak self] (item) in
            self?.showLoginPage()
        }
        view.addSubview(floatButton)
    }
    private func showReportPage() {
        //self.performSegue(withIdentifier: "showReportPage", sender: self)
        let vc:MBPhotoViewController = MBPhotoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    private func showLoginPage() {
        let vc:MBLoginViewController = MBLoginViewController()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        // Run the view's session
        sceneView.session.run(configuration)
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
    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
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
