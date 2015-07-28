//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by David Kim on 6/18/15.
//  Copyright (c) 2015 David Kim. All rights reserved.
//

import UIKit
import AVFoundation

//first screen - record
class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    //declare variables
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var tapToRecord: UILabel!

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        //on the opening page, hide the stop button, show the record button, and display 'tap to record'
        stopButton.hidden = true
        recordButton.enabled = true
        tapToRecord.hidden = false
    }

    @IBAction func recordAudio(sender: UIButton) {
        //while recording, show the stop button, replace 'tap to record' with 'recording', and gray out the record button
        stopButton.hidden = false
        recordingInProgress.hidden = false
        tapToRecord.hidden = true
        recordButton.enabled = false

        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        
        //name the file being recorded and set path
        let recordingName = "my_audio.wav"
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
        if(flag){
            //initialize recorder
            recordedAudio = RecordedAudio(fromRecorderURL: recorder.url, fromRecorderTitle: recorder.url.lastPathComponent!)
        
            //after recording is completed, move to the next screen
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }else{
            println("Recording was not successful")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    @IBAction func stopRecording(sender: UIButton) {
        recordingInProgress.hidden = true
        
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
}

