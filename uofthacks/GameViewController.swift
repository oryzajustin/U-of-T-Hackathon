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

struct GlobalAudio{
    static var blow = false
}

class GameViewController: UIViewController, AVAudioRecorderDelegate
{
    var audioRecorder: AVAudioRecorder!
    var recordingSession: AVAudioSession!
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
        
        recordingSession = AVAudioSession.sharedInstance()
        do {
            recordingSession.requestRecordPermission() { [unowned self] (allowed: Bool) -> Void in
                DispatchQueue.main.async{
                    if allowed {
                        print("Allowd Permission Record!!")
                        self.initializeRecorder ()
                        self.audioRecorder!.record()
                        
                        //instantiate a timer to be called with whatever frequency we want to grab metering values
                        self.levelTimer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(GameViewController.levelTimerCallback), userInfo: nil, repeats: true)
                        
                    } else {
                        // failed to record!
                        print("Failed Permission Record!!")
                    }
                }
            }
        } catch {
            // failed to record!
            print("Failed Permission Record!!")
        }
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    
    func initializeRecorder(){
        do{
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            
        }catch{
            print(error);
        }
        
        
        let stringDir:NSString = self.getDocumentsDirectory() as NSString;
        let audioFilename = stringDir.appendingPathComponent("recording.m4a")
        let audioURL = NSURL(fileURLWithPath: audioFilename)
        print("File Path : \(audioFilename)");
        
        // make a dictionary to hold the recording settings so we can instantiate our AVAudioRecorder
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000.0,
            AVNumberOfChannelsKey: 1 as NSNumber,
            AVEncoderBitRateKey:12800 as NSNumber,
            AVLinearPCMBitDepthKey:16 as NSNumber,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ] as [String : Any]
        
        do {
            if audioRecorder == nil
            {
                audioRecorder = try AVAudioRecorder(url: audioURL as URL, settings: settings )
                audioRecorder.delegate = self
                audioRecorder.prepareToRecord();
                audioRecorder.isMeteringEnabled = true;
            }
            audioRecorder!.record(forDuration: TimeInterval(5.0));
        } catch {
            print("Error")
        }
        
    }
    
    //GET DOCUMENT DIR PATH
    func getDocumentsDirectory() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    //This selector/function is called every time our timer (levelTime) fires
    func levelTimerCallback() {
        //we have to update meters before we can get the metering values
        if audioRecorder != nil
        {
            audioRecorder!.updateMeters()
            
            let ALPHA : Double = 0.05;
            let peakPowerForChannel : Double = pow(Double(10.0), (0.05) * Double(audioRecorder!.peakPower(forChannel: 0)));
            lowPassResults = ALPHA * peakPowerForChannel + Double((1.0) - ALPHA) * lowPassResults;
            print("low pass res = \(lowPassResults)");
            if (lowPassResults > 0.7 ){
                print("Mic blow detected");
                GlobalAudio.blow = true
            }
            GlobalAudio.blow = false
        }
        
        
    }
    //STOP RECORDING
    @IBAction func btnStopPress(sender: AnyObject) {
        
        if audioRecorder != nil
        {
            audioRecorder!.stop()
            self.levelTimer.invalidate()
        }
        
    }
}

