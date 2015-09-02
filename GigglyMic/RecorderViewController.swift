//
//  RecorderViewController.swift
//  GigglyMic
//
//  Created by Saqib Omer on 9/2/15.
//  Copyright (c) 2015 Kaboom Labs. All rights reserved.
//

import UIKit
import AVFoundation

class RecorderViewController: UIViewController,AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    // Properties
    // Play Recorded Audio Button : Initially hidden
    
    @IBOutlet weak var audioRecordButton: UIButton!
    @IBOutlet weak var playAudioButton: UIButton!
    @IBOutlet weak var audioRecorderLabel: UILabel!
    
    //Audio Recorder
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    var soundFileURL : NSURL!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide Audio Button
        playAudioButton.hidden = true  
        audioRecorderLabel.text = "Record an Audio"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    func stopAudioRecording () {
        
        audioRecordButton.hidden = true
        println("Audio Recording Stopped")
        audioRecorder?.stop()
        playAudioButton.hidden = false
        audioRecorderLabel.text = "Play"
        
        
    }
    
    @IBAction func recordAudioAction(sender: AnyObject) {
        
        // Record Audio for 10 seconds
        var timer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: Selector("stopAudioRecording"), userInfo: nil, repeats: false)
        
        audioRecorderLabel.text = "Recording..."
        
        //Animation
        var animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = NSNumber(float: 0.9)
        animation.duration = 0.5
        animation.repeatCount = 10.0
        animation.autoreverses = true
        audioRecorderLabel.layer.addAnimation(animation, forKey: nil)
        
        
        let dirPaths =
        NSSearchPathForDirectoriesInDomains(.DocumentDirectory,
            .UserDomainMask, true)
        let docsDir = dirPaths[0] as! String
        let soundFilePath =
        docsDir.stringByAppendingPathComponent("sound.caf")
        soundFileURL = NSURL(fileURLWithPath: soundFilePath)
        
        let recordSettings =
        [AVEncoderAudioQualityKey: AVAudioQuality.Min.rawValue,
            AVEncoderBitRateKey: 16,
            AVNumberOfChannelsKey: 2,
            AVSampleRateKey: 44100.0]
        
        var error: NSError?
        
        let audioSession = AVAudioSession.sharedInstance()
        audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord,
            error: &error)
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        }
        
        audioRecorder = AVAudioRecorder(URL: soundFileURL,
            settings: recordSettings as [NSObject : AnyObject], error: &error)
        
        if let err = error {
            println("audioSession error: \(err.localizedDescription)")
        } else {
            audioRecorder?.prepareToRecord()
        }
        
        
        if audioRecorder?.recording == false {
            println("Audio Recording Started")
            audioRecordButton.enabled = false
            audioRecorder?.record()
        }
    }
    
    
    // Mark: - Play Audio
    
    @IBAction func playAudioAction(sender: AnyObject) {
        
        
        if audioRecorder?.recording == false {
            //            stopButton.enabled = true
            //            recordButton.enabled = false
            
            var error: NSError?
            
            audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder?.url,
                error: &error)
            
            //            audioPlayer?.delegate = self
            
            if let err = error {
                println("audioPlayer error: \(err.localizedDescription)")
            } else {
                
                audioPlayer?.prepareToPlay()
                audioPlayer?.delegate = self
                audioPlayer?.play()
                
                //Animation
                var animation = CABasicAnimation(keyPath: "transform.scale")
                animation.toValue = NSNumber(float: 0.9)
                animation.duration = 0.5
                animation.repeatCount = 10.0
                animation.autoreverses = true
                playAudioButton.layer.addAnimation(animation, forKey: nil)
                
            }
        }
        
        
    }

    
    
    // AVAudio Player Delegate
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        
        audioRecorderLabel.text = "Record an Audio"
        playAudioButton.hidden = true
        audioRecordButton.hidden = false
        audioRecordButton.enabled = true
        println("Finished")
        
        
    }
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        println("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        println("Finished recording")
        println(soundFileURL)
        
    }
    
    func audioRecorderEncodeErrorDidOccur(recorder: AVAudioRecorder!, error: NSError!) {
        println("Audio Record Encode Error")
    }
    
    
}


