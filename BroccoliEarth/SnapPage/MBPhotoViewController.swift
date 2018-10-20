//
//  MBPhotoViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/16.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import AVFoundation

class MBPhotoViewController: BaseViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var closeBut: UIButton!
    @IBOutlet weak var centerBut: UIButton!
    @IBOutlet weak var innerBut: UIButton!

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    var imageSize:CGSize {
        return previewView.bounds.size
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhotoCapture()
        renderUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession?.startRunning()
        previewView.layoutIfNeeded()
        videoPreviewLayer?.frame.size = previewView.bounds.size
    }
    private func renderUI() {
        takePhotoButton.layer.cornerRadius = takePhotoButton.frame.size.width / 2
        takePhotoButton.backgroundColor = UIColor.white
        takePhotoButton.clipsToBounds = true
        centerBut.layer.cornerRadius = centerBut.frame.size.width / 2
        centerBut.clipsToBounds = true
        innerBut.layer.cornerRadius = innerBut.frame.size.width / 2
        innerBut.clipsToBounds = true
        closeBut.imageView?.image = UIImage(named: "delete")?.withRenderingMode(.alwaysTemplate)
        closeBut.tintColor = UIColor.white
        view.bringSubviewToFront(takePhotoButton)
        view.bringSubviewToFront(centerBut)
        view.bringSubviewToFront(innerBut)
        view.bringSubviewToFront(closeBut)
    }
    @IBAction func takePhoto(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }

    @IBAction func closePage(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    private func setPhotoCapture() {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            captureSession?.addOutput(capturePhotoOutput!)
        } catch {
            print(error)
        }
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        videoPreviewLayer?.videoGravity = .resizeAspectFill
        previewView.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
    }
    private func showReportPage(_ img:UIImage?) {
        self.performSegue(withIdentifier: "showReportDetailPage", sender: img)
    }
}
extension MBPhotoViewController:AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print(photo.timestamp)
        if let uu = photo.fileDataRepresentation() {
            let image = UIImage(data: uu, scale: 1.0)
            let resizeImag = image?.resize(with: imageSize)
            let showImag = UIImageView(image: resizeImag)
            showImag.contentMode = .scaleAspectFill
            showImag.clipsToBounds = true
            showReportPage(resizeImag)
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "showReportDetailPage":
            guard let vc = segue.destination as? MBReportPage else {
                return
            }
            guard let image = sender as? UIImage else {
                return
            }
            vc.showImage = image
        default:
            break
        }
    }
}
extension UIImage{

    func resize(with newSize: CGSize) -> UIImage {
        let newSize = CGSize(width: newSize.width, height: newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }


}
