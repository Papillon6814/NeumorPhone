//
//  ViewController.swift
//  NeumorPhone
//
//  Created by Papillon on 2020/02/19.
//  Copyright © 2020 Papillon. All rights reserved.
//

import UIKit
import ReplayKit

class ViewController: UIViewController {
    
    let rpScreenRecorder: RPScreenRecorder = RPScreenRecorder.shared()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startScreenCapture(_ sender: Any) {
        //rpScreenRecorder.startCapture(handler: <#T##((CMSampleBuffer, RPSampleBufferType, Error?) -> Void)?##((CMSampleBuffer, RPSampleBufferType, Error?) -> Void)?##(CMSampleBuffer, RPSampleBufferType, Error?) -> Void#>, completionHandler: <#T##((Error?) -> Void)?##((Error?) -> Void)?##(Error?) -> Void#>)
    }
}

