//
//  ViewController.swift
//  NeumorPhone
//
//  Created by Papillon on 2020/02/19.
//  Copyright © 2020 Papillon. All rights reserved.
//

import UIKit
import ReplayKit
import VideoToolbox
import HaishinKit

class ViewController: UIViewController, RPScreenRecorderDelegate {
    
    let rpScreenRecorder: RPScreenRecorder = RPScreenRecorder.shared()
    private var broadcaster: RTMPBroadcaster = RTMPBroadcaster()
    
    // MARK: Camera
    var sharedRecorder: RPScreenRecorder? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        sharedRecorder = RPScreenRecorder.shared()
//        broadcaster.streamName = "sampleStream"
//        broadcaster.connect("rtmp://0.0.0.0:1935/", arguments: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func startScreenCapture(_ sender: UIButton) {
        rpScreenRecorder.startCapture(handler: { (cmSampleBuffer, rpSampleBufferType, error) in
            if (error != nil) {
                print("Error occurred: \(error.debugDescription)")
            } else {
                if (rpSampleBufferType == RPSampleBufferType.audioApp) {
                    print("Audio")
                    self.broadcaster.appendSampleBuffer(cmSampleBuffer, withType: .audio)
                    
                } else if (rpSampleBufferType == RPSampleBufferType.video) {
                    print("video")
                    
                    if let description: CMVideoFormatDescription = CMSampleBufferGetFormatDescription(cmSampleBuffer) {
                        let dimensions: CMVideoDimensions = CMVideoFormatDescriptionGetDimensions(description)
                        self.broadcaster.stream.videoSettings = [
                            H264Encoder.Option.width: dimensions.width,
                            H264Encoder.Option.height: dimensions.height,
                            H264Encoder.Option.profileLevel: kVTProfileLevel_H264_Baseline_AutoLevel
                            ]
                    }
                    self.broadcaster.appendSampleBuffer(cmSampleBuffer, withType: .video)
                }
            }
        }, completionHandler: { (error) in
            if (error != nil) {
                print("error occurred: \(error.debugDescription)")
            } else {
                print("Success")
                sender.isEnabled = false
            }
        })
    }
    
    @IBAction func stopScreenCapture(_ sender: Any) {
        rpScreenRecorder.stopCapture(handler: { (error) in
            if error != nil {
                print("Error occurred: \(error.debugDescription)")
            } else {
                print("Success")
            }
        })
    }
    
    
    // MARK: RPScreenRecorderDelegate
    public func screenRecorder(_ screenRecorder: RPScreenRecorder, didStopRecordingWith previewViewController: RPPreviewViewController?, error: Error?) {
        print("Stopped recording")
    }
    
    public func screenRecorderDidChangeAvailability(_ screenRecorder: RPScreenRecorder) {
        print("Screen recorder changed the availability")
    }
}

