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
    let location:CLLocationCoordinate2D
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
                addMockLocation()
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
        let scene:SCNScene = SCNScene(named: "art.scnassets/Mosquito_Color.scn")!
        // Set the scene to the view
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
        for item in mockLocation.locations {
            let location = CLLocation(latitude: item.latitude ?? 0, longitude: item.longitude ?? 0)
            let mosquitoNode = SCNScene(named: "art.scnassets/ship.scn")!.rootNode.clone()
            let mosquitoLocationNode = LocationSceneNode(location: location, node: mosquitoNode)
            sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: mosquitoLocationNode)

            sceneView.scene.rootNode.addChildNode(mosquitoNode)
        }
    }
    private func transform(_ lati:CLLocationDegrees?, _ long:CLLocationDegrees?) -> CLLocationCoordinate2D {
        guard let lati = lati, let long = long else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        return CLLocationCoordinate2D(latitude: lati, longitude: long)
    }
    private func renderLocationNode(_ locations:[CLLocationCoordinate2D]) {
        let _ = LocationNode.render(locations: locations)
        let altitude = CLLocationDistance(exactly: currentAltitude)
        let houseLocation = CLLocation(coordinate:  currentLocation ?? CLLocationCoordinate2D(latitude: 25.030746, longitude: 121.549358), altitude: 21)
        let ship = SCNScene(named: "art.scnassets/ship.scn")!.rootNode.clone()
        let shipNode = LocationSceneNode(location: houseLocation, node: ship)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: shipNode)
        let myCurrentTest = CLLocation(coordinate:  currentLocation ?? CLLocationCoordinate2D(latitude: 25.030746, longitude: 121.549358), altitude: 21)
        let mosquito2 = SCNScene(named: "art.scnassets/Mosquito_Color.scn")!.rootNode.clone()
        let mosquito2Node = LocationSceneNode(location: myCurrentTest, node: mosquito2)
        sceneLocationView.addLocationNodeWithConfirmedLocation(locationNode: mosquito2Node)
        sceneView.scene.rootNode.addChildNode(mosquito2)
        sceneView.scene.rootNode.addChildNode(ship)
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
        var locations:[CLLocationCoordinate2D] = [CLLocationCoordinate2D]()
        for item in report {
            let coordinate1 = self.transform(CLLocationDegrees(exactly: item.latitude ?? 0), CLLocationDegrees(exactly: item.longitude ?? 0))
            locations.append(coordinate1)
            let showItem = ShowReport(img: nil, location: coordinate1, comment: item.description, type: item.type)
            reports.append(showItem)
//            guard let url = item.url else {
//                return
//            }
//            let imgUrl = URL(string: url)
//            UIImageView().sd_setImage(with: imgUrl) { (img, _, _, _) in
//                let coordinate1 = self.transform(CLLocationDegrees(exactly: item.latitude ?? 0), CLLocationDegrees(exactly: item.longitude ?? 0))
//                let showItem = ShowReport(img: img, location: coordinate1, comment: item.description, type: item.type)
//                reports.append(showItem)
//                let locations = reports.map({ (item) -> CLLocationCoordinate2D in
//                    return item.location
//                })
//                self.renderLocationNode(locations)
//            }
        }
        self.renderLocationNode(locations)
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
        print(currentLocation?.latitude.description)
        print(currentLocation?.longitude.description)
        print(currentAltitude)
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

