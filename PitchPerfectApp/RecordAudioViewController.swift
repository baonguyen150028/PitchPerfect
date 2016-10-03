//
//  ViewController.swift
//  PitchPerfectApp
//
//  Created by The Bao on 9/30/16.
//  Copyright © 2016 The Bao. All rights reserved.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet var hintLabel: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var resumeButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    let data = DataModel()

    override func viewWillAppear(_ animated: Bool) {
        
        hintLabel.text = data.getRandomHint()

        fadeInAnimate(recordButton)

        recordingLabel.text = data.helpText["startRecordText"]

        stopButton.isEnabled = false

        audioControllsHidden(true)

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: AnyObject) {

        // Show text to let user know in recording progress.

        recordingLabel.text = data.helpText["recordingText"]

        //Show all recording controls:
        audioControllsHidden(false)

        //Enable stop and pause buttons during recording:
        stopButton.isEnabled = true
        pauseButton.isEnabled = true
        resumeButton.isEnabled = false

        //Create the filepath and URL for the audio file.
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "pitchPerfect_recored.wav"

        //Load pathArray to set filePath url.
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURL(withPathComponents: pathArray)
        print(filePath)

        // Reset the audio recorder session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])

        //Set the delegate of the audioRecorder to the viewController
        audioRecorder.delegate = self

        //Prepare then start recording:
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        fadeOutInAnimate(sender as? UIButton)

    }


    @IBAction func resumeAudio(_ sender: AnyObject) {

        //Label text to indicate users that recording is paused:
        recordingLabel.text = data.helpText["recordingText"]

        // Continue recorder
        audioRecorder.record()

        //Enable pause button while paused:
        pauseButton.isEnabled = true

        //Disable resume button while paused:
        resumeButton.isEnabled = false

    }

    @IBAction func pauseAudio(_ sender: AnyObject) {
        //Label text to indicate users that recording is paused:
        recordingLabel.text = data.helpText["pauseRecordText"]

        // Pause audioRecorder
        audioRecorder.pause()

        //Disable pause button while paused:
        pauseButton.isEnabled = false

        //Resume button enabled while paused:
        resumeButton.isEnabled = true
    }

    @IBAction func stopAudio(_ sender: AnyObject) {
        // Enable recordButton and display useful text to let user know in stopAudio
        recordButton.isEnabled = true



        recordingLabel.text = data.helpText["startRecordText"]

        //Hide all recording controls:
        audioControllsHidden(true)

        // Stop audioRecorder
        audioRecorder.stop()
        // Stop audioSession
        let audioSession = AVAudioSession.sharedInstance()

        // try-catch to prevent error crashes if audioSession can not active
        do {
        try audioSession.setActive(false)
        }   catch { print("Error, audioSession activation is failed") }


    }

    func audioControllsHidden(_ hidden:Bool){
        //Hide (true) or show (false) recording controls (play, pause, resume)
        stopButton.isHidden = hidden
        pauseButton.isHidden = hidden
        resumeButton.isHidden = hidden
    }

    func fadeOutInAnimate(_ button: UIButton?) {
        //Fade button in and out:
        button?.fadeOutAndIn()
    }
    func fadeInAnimate(_ button: UIButton?) {

        button?.fadeIn(duration: 1.0, delay: 0.0, completion: nil)
    }


    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("Finish Recording")
        if (flag){
        //If audioRecorderDidFinishRecording, perform Segue (prepare data to move on second view controller)
            self.performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving Failed! Please try again. ")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get data from second view controller using segue.destination.

        if (segue.identifier == "stopRecording") {
            let playSoundsVC = segue.destination as! PlayAudioViewController
            
            //Create an object
            let recordedAudioURL = sender as! NSURL
            //Pass the data to the playAudioVC
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }

}

