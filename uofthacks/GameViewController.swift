//
//  GameViewController.swift
//  uofthacks
//
//  Created by Justin Koh, Michelle Chen
//

import UIKit
import SpriteKit
import GameplayKit

import Foundation
import AVFoundation
import CoreAudio

class GameViewController: UIViewController
{
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    var lowPassResults: Double = 0.0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
        
//        //make Audio Session
//        var audioSession: AVAudioSession = AVAudioSession.sharedInstance()
//        do {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
//            try audioSession.setActive(true)
//        }
//        catch{
//        }
//        
//        //set up URL for audio file
//        var documents: AnyObject = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as AnyObject
//        var str = documents.appendingPathComponent("recordTest.caf")
//        let url = NSURL.fileURL(withPath: str)
//        
//        //make a dictionary to hold recording settings
//        var recordSettings : [NSObject : AnyObject] = [AVFormatIDKey as NSObject: kAudioFormatAppleIMA4 as AnyObject,
//                                                       AVSampleRateKey as NSObject: 44100.0 as AnyObject,
//                                                       AVNumberOfChannelsKey as NSObject:2 as AnyObject,
//                                                       AVEncoderBitRateKey as NSObject: 12800 as AnyObject,
//                                                       AVLinearPCMBitDepthKey as NSObject: 16 as AnyObject,
//                                                       AVEncoderAudioQualityKey as NSObject: AVAudioQuality.max.rawValue as AnyObject]
//        //decalre a variable to store returned error
//        var error: NSError?
//        
//        
//        recorder = AVAudioRecorder(URL: url, settings: recordSettings, error:&error)
//        
//        if let e = error{
//            print(e.localizedDescription)
//        }
//        else{
//            recorder.prepareToRecord()
//            recorder.isMeteringEnabled = true
//            
//            //start recording
//            recorder.record()
//            
//        }
//    }
//    
//    func levelTimerCallback(timer: Timer){
//        recorder.updateMeters()
//        
//        if recorder.averagePower(forChannel: 0) > -7{
//            print(recorder.averagePower(forChannel: 0))
//        }
//    }
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
}
