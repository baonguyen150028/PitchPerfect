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

    @IBOutlet var recordButton: UIButton!
    @IBOutlet var recordingLabel: UILabel!
    @IBOutlet var resumeButton: UIButton!
    @IBOutlet var stopButton: UIButton!
    @IBOutlet var pauseButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    // Show progress doing for users
 


    override func viewWillAppear(_ animated: Bool) {

        stopButton.isEnabled = false
        resumeButton.isEnabled = false
        pauseButton.isEnabled = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        recordingLabel.text = DataModel.helpText.startRecordText

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(_ sender: AnyObject) {

        // Show text to let user know in recording progress.
        recordingLabel.text = DataModel.helpText.RecordingText

        // Disable record button and enable stop record button when recording.
        stopButton.isEnabled = true
        recordButton.isEnabled = false
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
    }


    @IBAction func resumeAudio(_ sender: AnyObject) {

        //Label text to indicate users that recording is paused:
        recordingLabel.text = DataModel.helpText.RecordingText

        // Continue recorder
        audioRecorder.record()

        //Enable pause button while paused:
        pauseButton.isEnabled = true

        //Disable resume button while paused:
        resumeButton.isEnabled = false

    }

    @IBAction func pauseAudio(_ sender: AnyObject) {
        //Label text to indicate users that recording is paused:
        recordingLabel.text = DataModel.helpText.pauseRecordText

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
        recordingLabel.text = DataModel.helpText.startRecordText

        // Disable stop button
        stopButton.isEnabled = false

        // Stop audioRecorder
        audioRecorder.stop()
        // Stop audioSession
        let audioSession = AVAudioSession.sharedInstance()

        // try-catch to prevent error crashes if audioSession can not active
        do {
        try audioSession.setActive(false)
        }   catch { print("Error, audioSession activation is failed") }


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

