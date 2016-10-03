//
//  PlaySoundsViewController+Audio.swift
//  PitchPerfect
//
//  Copyright © 2016 Udacity. All rights reserved.
//
import UIKit
import AVFoundation
import GameKit
class DataModel: UIViewController {

    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error"
        static let AudioEngineError = "Audio Engine Error"
    }
    let helpText: [String:String] = [
        "startRecordText" : "Tap to record",
        "recordingText" : "Recording...",
        "pauseRecordText" : "Paused",
    ]

    let hintText:[String] = [
            "Avoid noise to record better.",
            "Use pause button to pause recording progress",
            "Make some funny melody :D"
    ]
    // Get random hint text to hintLabel

    func getRandomHint() -> String {

        let randomHint  = GKRandomSource.sharedRandom().nextInt(upperBound: hintText.count)

        return hintText[randomHint]
    }


    
}









