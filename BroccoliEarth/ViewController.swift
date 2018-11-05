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

struct ShowReport {
    let img:UIImage?
    let location:CLLocation
    var comment:String?
    var type:String?
}
class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!

    var floatButton:Floaty = Floaty(size: 65)
    var sceneLocationView = SceneLocationView()
    var currentAltitude:CLLocationDistance = 0
    var currentLocation:CLLocationCoordinate2D? {
        didSet {
            if oldValue == nil {
                userManager.location = currentLocation
                getLocationStatus()
                getMyLocationReport()
            }
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var profile: UIImageView!
    var testLocation:CLLocationCoordinate2D?
    private let client:MainService = MainService()
    let configuration = ARWorldTrackingConfiguration()
    let mockLocation:MockLoactions = MockLoactions()
    var mockLocationNode:[LocationSceneNode] = [LocationSceneNode]()
    var mockNode:[SCNNode] = [SCNNode]()
    private var myShowReport:[ShowReport] = [ShowReport]() {
        didSet {
            renderLocationNode(myShowReport)
        }
    }
    private var reportImgs:[UIImage?] = [UIImage?]() {
        didSet {

        }
    }

    @IBOutlet weak var statusAlertView: UILabel!
    private let userManager:UserManager = UserManager.shared
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = true
        // Create a session configuration
        // Run the view's session
        sceneView.session.run(configuration)
        progressView.setProgress(Float(userManager.userlevel ?? 1), animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        // Create a new scene
        sceneLocationView.locationDelegate = self
        progressView.setProgress(Float(userManager.userlevel ?? 0), animated: true)
        userManager.update = { [weak self] user in
            self?.nameLabel.text = user.name
            self?.profile.sd_setImage(with: user.image) { (image, error, cache, url) in
                print(error?.localizedDescription ?? "an error occur")
            }
        }
//        let scene:SCNScene = SCNScene(named: "art.scnassets/Mosquito_Color.scn")!
        let scene:SCNScene = SCNScene()
        sceneView.scene = scene
        sceneLocationView.run()
        view.addSubview(sceneLocationView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnScene(gesture:)))
        sceneLocationView.addGestureRecognizer(tap)
        userManager.login()
        renderUi()
        var locationsss:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        let coordinate1 = transform(CLLocationDegrees(exactly: 25.064879), CLLocationDegrees(exactly: 121.537740))
        locationsss.append(coordinate1)

        let location = CLLocation(coordinate: coordinate1, altitude: 10)
        let image = UIImage(named: "mosquitoPlant")!
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: annotationNode)
    }
    @objc private func didTapOnScene(gesture: UITapGestureRecognizer) {
        if gesture.state == .ended {
            let location: CGPoint = gesture.location(in:sceneView)
            let hits = sceneView.hitTest(location, options: nil)
            if !hits.isEmpty{
                let touchedNode = hits.first?.node
                if let locationNode = getLocationNode(node: touchedNode) {
                    print(locationNode)
                }
            }
        }
    }
    private func addLocationNote(at location:CLLocation, with rootNode:SCNNode?) {
        guard let rootNode = rootNode else {
            return
        }
        let location = CLLocation(coordinate: location.coordinate, altitude: location.altitude)
        let image = UIImage(named: "dialog")!
        let annotationNode = LocationAnnotationNode(location: location, image: image)
        annotationNode.annotationNode.scale = SCNVector3(0.05, 0.05, 0.05)
        annotationNode.annotationNode.localTranslate(by: SCNVector3(0, 0, -0.5))
        rootNode.addChildNode(annotationNode.annotationNode)
    }
    func getLocationNode(node: SCNNode?) -> SCNNode? {
        guard let node = node else {return nil}
        var nodeStack:[SCNNode] = [SCNNode]()
        nodeStack.append(node)
        if let hint = node.accessibilityHint {
            let jjj = mockLocationNode.filter { (item) -> Bool in
                return item.tag == hint
            }
            if let sameNode =  jjj.first {
                print(sameNode.location)
                addLocationNote(at: sameNode.location, with: nodeStack.first)
                print(currentLocation)
            }
            return node
        } else {
            if let parenNode = node.parent {
                return getLocationNode(node: parenNode)
            }
             return nil
        }
    }
    private func getLocationStatus() {
        client.getCurrentLocationAlarm {[weak self] (status) in
            guard let status = status else {return}
            self?.statusAlertView.text = status.warningTitle
            switch status {
            case .aware:
                self?.statusAlertView.backgroundColor = UIColor("#f95a15")
            case .good:
                self?.statusAlertView.backgroundColor = UIColor("#016616")
            case .soso:
                self?.statusAlertView.backgroundColor = UIColor.blue
            case .dangerous:
                self?.statusAlertView.backgroundColor = UIColor.red
            }
        }
    }
    private func addMockLocation() {
        let altitude = CLLocationDistance(exactly: currentAltitude)
        var mockLocationNodeTemp:[LocationSceneNode] = [LocationSceneNode]()
        var mockNodeTemp:[SCNNode] = [SCNNode]()
        var i = 0
        for item in mockLocation.locations {
            i += 1
            let location = CLLocation(coordinate: CLLocationCoordinate2D(latitude: item.latitude ?? 0, longitude: item.longitude ?? 0), altitude: altitude ?? 10)
            let mosquitoNode = SCNScene(named: "art.scnassets/Mosquito_Color.scn")!.rootNode.clone()
            mosquitoNode.accessibilityHint = "\(i)"
            mockNodeTemp.append(mosquitoNode)
            let mosquitoLocationNode = LocationSceneNode(location: location, node: mosquitoNode)
            mosquitoLocationNode.tag = "\(i)"
            mockLocationNodeTemp.append(mosquitoLocationNode)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: mosquitoLocationNode)
            sceneView.scene.rootNode.addChildNode(mosquitoNode)
        }
        mockLocationNode = mockLocationNodeTemp
        mockNode = mockNodeTemp
    }
    private func transform(_ lati:CLLocationDegrees?, _ long:CLLocationDegrees?) -> CLLocationCoordinate2D {
        guard let lati = lati, let long = long else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        return CLLocationCoordinate2D(latitude: lati, longitude: long)
    }
    private func renderLocationNode(_ locations:[ShowReport]) {
        var locationNodeTemp:[LocationSceneNode] = [LocationSceneNode]()
        var nodeTemp:[SCNNode] = [SCNNode]()
        var i = 0
        for item in locations {

            i += 1
            let mosquitoNode = SCNScene(named: "art.scnassets/Mosquito_Color.scn")!.rootNode.clone()
            mosquitoNode.accessibilityHint = "\(i)"
            nodeTemp.append(mosquitoNode)
            let mosquitoLocationNode = LocationSceneNode(location: item.location, node: mosquitoNode)
            mosquitoLocationNode.tag = "\(i)"
            locationNodeTemp.append(mosquitoLocationNode)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: mosquitoLocationNode)
            sceneView.scene.rootNode.addChildNode(mosquitoNode)
        }
        mockLocationNode = locationNodeTemp
        mockNode = nodeTemp
    }
    private func renderUi() {
        floatButton.buttonColor = UIColor("#c44056")
        floatButton.frame.origin.y = view.frame.size.height - 80
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
    private func getAllShowReport(_ report:[MBReport]?) {
        guard let report = report else {return}
        var reports:[ShowReport] = [ShowReport]()
        for item in report {
            guard let latitude = item.latitude, let longitude = item.longitude else {return}
            let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let location = CLLocation(coordinate: coordinate, altitude: currentAltitude)
                let imgUrl = URL(string: item.url ?? "")
                UIImageView().sd_setImage(with: imgUrl) { [weak self] (img, _, _, _) in
                    let showItem = ShowReport(img: img, location: location, comment: item.description, type: item.type)
                    reports.append(showItem)
                    self?.myShowReport = reports
                }
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
        client.sendMyLocation(at: currentLocation) { [weak self] (result) in
            guard let reports = result else {return}
            self?.getAllShowReport(reports.data)
        }
    }
    //private func transform
    internal func addNode(at location:CLLocationCoordinate2D) {
        if currentLocation != nil {
            return
        }
        currentLocation = location
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
        currentLocation = location.coordinate
        currentAltitude = location.altitude
        print(currentLocation)

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

