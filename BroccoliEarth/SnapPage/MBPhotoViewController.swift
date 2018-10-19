//
//  MBPhotoViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/16.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import AVFoundation

class MBPhotoViewController: UIViewController {

    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var closeBut: UIButton!

    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhotoCapture()
        renderUI()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        captureSession?.startRunning()
        videoPreviewLayer?.frame.size = previewView.bounds.size
    }
    private func renderUI() {
        takePhotoButton.layer.cornerRadius = takePhotoButton.frame.size.width / 2
        takePhotoButton.backgroundColor = UIColor("#2d4868")
        takePhotoButton.clipsToBounds = true
        view.bringSubviewToFront(takePhotoButton)
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
        videoPreviewLayer?.videoGravity = .resize
        previewView.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
    }
    private func showReportPage(_ img:UIImage?) {
        let reportPage = MBReportPage(with: img)
        navigationController?.pushViewController(reportPage, animated: true)
    }
}
extension MBPhotoViewController:AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print(photo.timestamp)
        if let uu = photo.fileDataRepresentation() {
            let image = UIImage(data: uu, scale: 1.0)
            let resizeImag = image?.resize(with: previewView.bounds.size)
            let showImag = UIImageView(image: resizeImag)
            showImag.frame.size = previewView.bounds.size
            showImag.contentMode = .scaleAspectFit
            showImag.clipsToBounds = true
            showReportPage(showImag.image)
            //compress data image?.jpegData(compressionQuality: 0.75)
        }
    }
//    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
//
//    }
}
extension UIImage{

    func resize(with newSize: CGSize) -> UIImage {

        let horizontalRatio = newSize.width / size.width
        let verticalRatio = newSize.height / size.height

        let ratio = max(horizontalRatio, verticalRatio)
        let newSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        UIGraphicsBeginImageContextWithOptions(newSize, true, 0)
        draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }


}
