//
//  LiveCameraView.swift
//  
//
//  Created by Alexandra Afonasova on 18.10.2022.
//

import SwiftUI
import AVFoundation

@MainActor
public struct LiveCameraView: UIViewRepresentable {

    let session: AVCaptureSession
    let videoGravity: AVLayerVideoGravity
    let orientation: UIDeviceOrientation

    public func makeUIView(context: Context) -> LiveVideoCaptureView {
        LiveVideoCaptureView(
            session: session,
            videoGravity: videoGravity,
            orientation: orientation
        )
    }

    public func updateUIView(_ uiView: LiveVideoCaptureView, context: Context) {
        uiView.session = session
        uiView.videoLayer.videoGravity = videoGravity
    }
}

public final class LiveVideoCaptureView: UIView {

    var session: AVCaptureSession? {
        get {
            return videoLayer.session
        }
        set (session) {
            videoLayer.session = session
        }
    }

    public override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

    var videoLayer: AVCaptureVideoPreviewLayer { layer as! AVCaptureVideoPreviewLayer }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    init(
        frame: CGRect = .zero,
        session: AVCaptureSession? = nil,
        videoGravity: AVLayerVideoGravity = .resizeAspect,
        orientation: UIDeviceOrientation
    ) {
        super.init(frame: frame)

        DispatchQueue.main.async {
            self.session = session
            self.videoLayer.videoGravity = videoGravity
        }
    }
}
