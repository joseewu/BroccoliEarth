//
//  ReportViewController.swift
//  BroccoliEarth
//
//  Created by joseewu on 2018/10/16.
//  Copyright © 2018 com.js. All rights reserved.
//

import UIKit
import AVFoundation

class ReportViewController: UIViewController {
    let captureSession = AVCaptureSession()
    let imgTook = AVCaptureStillImageOutput()
    var error: NSError?
    override func viewDidLoad() {
        super.viewDidLoad()
        let devices = AVCaptureDevice.devices().filter{ $0.hasMediaType(.video) && $0.position == .back }
        if let captureDevice = devices.first as? AVCaptureDevice  {

            captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &error))
            captureSession.sessionPreset = AVCaptureSession.Preset.photo
            captureSession.startRunning()
            stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
            if captureSession.canAddOutput(imgTook) {
                captureSession.addOutput(imgTook)
            }
            if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
                previewLayer.bounds = view.bounds
                previewLayer.position = CGPointMake(view.bounds.midX, view.bounds.midY)
                previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
                let cameraPreview = UIView(frame: CGRect(0.0, 0.0, view.frame.size.width, view.frame.size.height))
                cameraPreview.layer.addSublayer(previewLayer)
                cameraPreview.addGestureRecognizer(UITapGestureRecognizer(target: self, action:"saveToCamera:"))
                view.addSubview(cameraPreview)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
