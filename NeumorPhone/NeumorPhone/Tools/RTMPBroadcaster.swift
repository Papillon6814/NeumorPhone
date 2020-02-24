//
//  RTMPBroadcaster.swift
//  NeumorPhone
//
//  Created by Papillon on 2020/02/19.
//  Copyright © 2020 Papillon. All rights reserved.
//

import HaishinKit
import CoreMedia
import AVFoundation

public class RTMPBroadcaster: RTMPConnection {
    public var streamName: String?
    
    public lazy var stream: RTMPStream = {
       return RTMPStream(connection: self)
    }()
    
    private lazy var spliter: SoundSpliter = {
        var spliter: SoundSpliter = SoundSpliter()
        spliter.delegate = self as? SoundSpliterDelegate
        return spliter
    }()
    private var connecting = false
    private let lockQueue = DispatchQueue(label: "com.haishinkit.HaishinKit.RTMPBroadcaster.lock")
    
    public override init() {
        super.init()
        addEventListener(Event.Name.rtmpStatus, selector: #selector(rtmpStatusEvent(_:)), observer: self)
    }
    
    deinit {
        removeEventListener(Event.Name.rtmpStatus, selector: #selector(rtmpStatusEvent(_:)), observer: self)
    }
    
    // WARNING: withType: CMSampleBuffer.Type => withType: AVMediaType
    func appendSampleBuffer(_ sampleBuffer: CMSampleBuffer, withType: AVMediaType, options: [NSObject: AnyObject]? = nil) {
        stream.appendSampleBuffer(sampleBuffer, withType: withType)
    }
    
    override public func connect(_ command: String, arguments: Any?...) {
        lockQueue.sync {
            connecting = true
            spliter.clear()
            super.connect(command, arguments: arguments)
        }
    }
    
    override public func close() {
        lockQueue.sync {
            self.connecting = false
            super.close()
        }
    }
    
    @objc func rtmpStatusEvent(_ status: Notification) {
        let e: Event = Event.from(status)
        guard
            let data: ASObject = e.data as? ASObject,
            let code: String = data["code"] as? String,
            let streamName: String = streamName else {
                return
        }
        
        switch code {
        case RTMPConnection.Code.connectSuccess.rawValue:
            stream.publish(streamName)
        default:
            break
        }
    }
}
