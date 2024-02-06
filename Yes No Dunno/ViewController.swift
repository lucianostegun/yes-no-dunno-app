//
//  ViewController.swift
//  Yes No Dunno
//
//  Created by Luciano Stegun on 03/02/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var dunnoButton: UIButton!
    @IBOutlet weak var configModeSwitch: UISwitch!
    
    var recorder: AVAudioRecorder?
    var player: AVAudioPlayer?
    var recordTag: String = ""
    var settings: [String: Any]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRecorder()
        self.setupButtons()
    }
    
    @IBAction func onClickYesButton(sender: UIButton) {
        recordTag = "yes";
        if (configModeSwitch.isOn) {
            sender.setTitle("GRAVANDO", for: .normal)
            self.record()
        } else {
            self.play()
        }
    }
    
    @IBAction func onClickNoButton(sender: UIButton) {
        recordTag = "no";
        if (configModeSwitch.isOn) {
            sender.setTitle("GRAVANDO", for: .normal)
            self.record()
        } else {
            self.play()
        }
    }
    
    @IBAction func onClickDunnoButton(sender: UIButton) {
        recordTag = "dunno";
        if (configModeSwitch.isOn) {
            sender.setTitle("GRAVANDO", for: .normal)
            self.record()
        } else {
            self.play()
        }
    }
    
    @IBAction func onTouchUpButton(sender: UIButton) {
        if (configModeSwitch.isOn) {
            print("Stop recording");
            recorder?.stop()
            self.play()
            
            switch (recordTag) {
            case "yes":
                yesButton.setTitle("SIM", for: .normal)
                break
            case "no":
                noButton.setTitle("NÃO", for: .normal)
                break
            case "dunno":
                dunnoButton.setTitle("NÃO SEI", for: .normal)
                break
            default:
                break
            }
        }
    }
    
    func setupButtons() {
            // Set corner radius for yesButton
//            yesButton.layer.cornerRadius = 20 // Adjust the value as needed
//            yesButton.clipsToBounds = true
//            yesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28) // Adjust the size as needed
//        
//            if let customFont = UIFont(name: "HelloHeadlineW00-Regular", size: 16) {
//                yesButton.titleLabel?.font = customFont
//            } else {
//                print("Custom font not found, make sure it is added to the project and Info.plist.")
//            }
        }
    
    func setupRecorder() {
        print("setupRecorder")
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Error setting audio session category: \(error.localizedDescription)")
        }
        
        // Recorder settings
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "audio_recording.wav"
        let filePathURL = directoryURL.appendingPathComponent(fileName)
        
        settings = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            recorder = try AVAudioRecorder(url: filePathURL, settings: settings!)
            recorder?.prepareToRecord()
        } catch {
            print("Error setting up recorder: \(error.localizedDescription)")
        }
    }
    
    func record() {
        print("Record");
        // Recorder settings
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "audio_recording_" + recordTag + ".wav"
        let filePathURL = directoryURL.appendingPathComponent(fileName)
        
        do {
            recorder = try AVAudioRecorder(url: filePathURL, settings: settings!)
            recorder?.prepareToRecord()
            recorder?.record()
            print("Recording")
        } catch {
            print("Error setting up recorder: \(error.localizedDescription)")
        }
    }

    func play() {
        // Set up and play the recorded audio
        print("Playing for " + recordTag)
        do {
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
        } catch {
            print("Error setting audio session category: \(error.localizedDescription)")
        }
        
        // Recorder settings
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileName = "audio_recording_" + recordTag + ".wav"
        let filePathURL = directoryURL.appendingPathComponent(fileName)
        
        print(filePathURL);
        do {
            player = try AVAudioPlayer(contentsOf: filePathURL)
            player?.play()
        } catch {
            print("Error playing recorded audio: \(error.localizedDescription)")
        }
    }
}

