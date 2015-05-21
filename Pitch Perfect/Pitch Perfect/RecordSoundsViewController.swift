//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Jeffrey Limauro on 5/21/15.
//  Copyright (c) 2015 LimauroDev. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    @IBOutlet weak var recordingInProgress: UILabel!

    @IBOutlet weak var recordButton: UIButton!
    
    @IBOutlet weak var stopButton: UIButton!
    var audioRecorder:AVAudioRecorder!
    
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
         stopButton.hidden = true
        recordButton.enabled = true
    }
    
    @IBAction func recordAudio(sender: UIButton) {
        println("in recordAudio")
        recordingInProgress.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag)
        {
        recordedAudio = RecordedAudio()
        // save
        recordedAudio.filePathUrl = recorder.url
        recordedAudio.title = recorder.url.lastPathComponent
        
        
        //move to second scene
        self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundViewController = segue.destinationViewController as! PlaySoundViewController
            
            let data = sender as! RecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
          println("stop recording")
        recordingInProgress.hidden = true
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        
        //TODO: Stop recording
    }

}

