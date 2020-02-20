//
//  ViewController.swift
//  NeumorPhone
//
//  Created by Papillon on 2020/02/19.
//  Copyright © 2020 Papillon. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController, RPScreenRecorderDelegate {
    
    let rpScreenRecorder: RPScreenRecorder = RPScreenRecorder.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startScreenCapture(_ sender: Any) {
        rpScreenRecorder.startCapture(handler: { (cmSampleBuffer, rpSampleBufferType, error) in
            if (error != nil) {
                print("Error is occurred: \(error.debugDescription)")
            } else {
                if (rpSampleBufferType == RPSampleBufferType.audioApp) {
                    print("Audio")
                } else if (rpSampleBufferType == RPSampleBufferType.video) {
                    print("video")
                }
            }
        }, completionHandler: { (error) in
            if (error != nil) {
                print("error occurred: \(error.debugDescription)")
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

