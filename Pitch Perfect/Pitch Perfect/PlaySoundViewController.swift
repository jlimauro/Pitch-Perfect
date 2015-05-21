//
//  PlaySoundViewController.swift
//  Pitch Perfect
//
//  Created by Jeffrey Limauro on 5/21/15.
//  Copyright (c) 2015 LimauroDev. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundViewController: UIViewController,AVAudioPlayerDelegate {
    
    var audioPlayer:AVAudioPlayer!
    var recievedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    @IBOutlet weak var stopButton2: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3"){
//            
//            // NSBundle.mainBundle().URLForResource("movie_quote", withExtension: "mp3")
//            
//            var filePathURL = NSURL.fileURLWithPath(filePath)
//            audioPlayer = AVAudioPlayer(contentsOfURL: filePathURL, error: nil)
//        }
//        else {println("the filePath is empty")}
        
        audioPlayer = AVAudioPlayer(contentsOfURL: recievedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        stopButton2.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopPlayBack(sender: UIButton) {
        audioPlayer.stop()
        stopButton2.hidden = true
    }
    @IBAction func playSoundSlow(sender: UIButton) {
        //play slow audio
        playAudio(0.5)
}

    @IBAction func playSoundFast(sender: UIButton) {
        //play slow audio
        playAudio(2)
    }
    
    @IBAction func playSoundChipmonk(sender: UIButton) {
        
        playAudioWithVariablePitch(1000)
        stopButton2.hidden = true
    }
    
    @IBAction func playSoundVader(sender: UIButton) {
        
         playAudioWithVariablePitch(-1000)
        stopButton2.hidden = true
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        stopButton2.hidden = false
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: audioPlayerNodeFinished())
        
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    func audioPlayerNodeFinished()
    {
        stopButton2.hidden = true
    }
    private func playAudio(rate: Float)
    {
        stopButton2.hidden = false
        audioPlayer.stop()
        audioPlayer.enableRate = true
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.prepareToPlay()
        audioPlayer.delegate = self
        setSessionPlayAndRecord()
        audioPlayer.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool)
    {
        if(flag)
        {
            stopButton2.hidden = true   
        }
    }
    
    func setSessionPlayAndRecord() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        var error: NSError?
        if !session.setCategory(AVAudioSessionCategoryPlayAndRecord, error:&error) {
            println("could not set session category")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error:&error) {
            println("could not set output to speaker")
            if let e = error {
                println(e.localizedDescription)
            }
        }
        if !session.setActive(true, error: &error) {
            println("could not make session active")
            if let e = error {
                println(e.localizedDescription)
            }
        }
    }
   
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

