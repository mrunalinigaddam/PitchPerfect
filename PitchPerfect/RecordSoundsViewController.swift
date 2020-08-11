//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Mrunalini Gaddam on 7/20/20.
//  Copyright © 2020 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        stopRecording.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear is called")
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        print("recorder button is pressed!")
        recordingLable.text = "recording in progress"
        recorder.isEnabled = false
        stopRecording.isEnabled = true
//        @IBAction func recordAudio(isRecording: Bool) {
//            stopRecording.isEnabled = isRecording // to disable the button
//            recorder.isEnabled = !isRecording // to enable the button
//            recordingLable.text = !isRecording ? "Tap to Record" : "Recording in Progress"
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
    
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func recorder(_ sender: UIButton) {
    }
    @IBOutlet weak var recordingLable: UILabel!
    
    @IBOutlet weak var stopRecording: UIButton!
    @IBOutlet weak var recorder: UIButton!
    @IBAction func stopRecording(_ sender: Any) {
        print("stop recording button is pressed")
        recordingLable.text = "Tap to record"
        stopRecording.isEnabled = false
        recorder.isEnabled = true
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag{
        performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            print("Finished recording!!")}
        else{
            print("recording interrupted!")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}
