//
//  PlayAudioViewController.swift
//  PitchPerfectApp
//
//  Created by The Bao on 9/30/16.
//  Copyright © 2016 The Bao. All rights reserved.
//

import UIKit
import AVFoundation
class PlayAudioViewController: UIViewController {


    @IBOutlet weak var stopButton: UIButton!
    // Create Object for AudioFile,AudioEngine,AudioPlayerNode and stopTimer
    var audioFile: AVAudioFile!
    var audioEngine: AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    var recordedAudioURL: NSURL!

    // Enum to switch play sound effect
    enum ButtonType: Int {case Slow = 0, Fast, Chipmunk, Varder, Echo, Reverb }

    // raw values correspond to sender tags

    // Play sound and config
    @IBAction func playSoundForButton(_ sender: UIButton) {

        print("Play Sound Button Pressed")

        switch(ButtonType(rawValue: sender.tag)!){
            case .Slow: playSound(rate: 0.5)
            case .Fast: playSound(rate: 1.5)
            case .Chipmunk: playSound(pitch: 1000)
            case .Varder: playSound(pitch: -1000)
            case .Echo: playSound(echo: true)
            case .Reverb: playSound(reverb: true)
        }
            stopButton.isEnabled = true
    }
    // Stop sound and config
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        print("Stop Audio Button Pressed")

        stopButton.isEnabled = false

        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }

        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }

        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        stopButton.isEnabled = false

        //  Preparing for playing audio
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
        } catch {
            showAlert(title: DataModel.Alerts.AudioFileError, message: String(describing: error))
        }
        print("Audio has been setup")


    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // Play sound with rate,pitch,echo,reverb effects.

    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {

        // initialize audio engine components
        audioEngine = AVAudioEngine()

        // node for playing audio
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)

        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode)

        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioEngine.attach(echoNode)

        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)

        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(nodes: audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(nodes: audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(nodes: audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
        } else {
            connectAudioNodes(nodes: audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
        }

        // schedule to play and start the engine!
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) {

            var delayInSeconds: Double = 0

            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {

                if let rate = rate {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }

            // schedule a stop timer for when audio finishes playing
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(getter: PlayAudioViewController.stopButton), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }

        do {
            try audioEngine.start()
        } catch {
            showAlert(title: DataModel.Alerts.AudioEngineError, message: String(describing: error))
            return
        }

        // play the recording!
        audioPlayerNode.play()
    }
    // Connect List of Audio Nodes

    func connectAudioNodes(nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    // Show an alert when app has a error
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: DataModel.Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}
