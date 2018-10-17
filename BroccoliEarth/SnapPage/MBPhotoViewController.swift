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
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var capturePhotoOutput: AVCapturePhotoOutput?
    override func viewDidLoad() {
        super.viewDidLoad()
        setPhotoCapture()
        renderUI()

    }
    @IBAction func takePhoto(_ sender: Any) {
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        let photoSettings = AVCapturePhotoSettings()
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .auto
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    private func renderUI() {
        takePhotoButton.layer.cornerRadius = takePhotoButton.frame.size.width / 2
        takePhotoButton.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        takePhotoButton.clipsToBounds = true
        previewView.bringSubviewToFront(takePhotoButton)
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
        videoPreviewLayer?.frame = UIScreen.main.bounds
        previewView.layer.addSublayer(videoPreviewLayer!)
        captureSession?.startRunning()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         captureSession?.startRunning()
    }
}
extension MBPhotoViewController:AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print(photo.timestamp)
//
//        fileDataRepresentation
    }
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

    }
}
