//
//  DetailViewController.swift
//  Speech
//
//  Created by Amy Lin on 9/10/18.
//  Copyright © 2018 Amy Lin. All rights reserved.
//

import UIKit
import AVFoundation;
import Foundation

@available(iOS 10.0, *)
class DetailViewController: UIViewController, AVAudioPlayerDelegate {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var leftText: UITextView!
    @IBOutlet weak var rightText: UITextView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var scrubber: UISlider!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var backUp: UIButton!
    @IBOutlet weak var skipForward: UIButton!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var SoundPlayer:AVAudioPlayer!
    var translate = false;
    var timer:Timer!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var translation:Translation!
    var transcript:Transcription!
    
    @IBAction func backPressed(_ sender: Any) {
    
        SoundPlayer.stop();
        _ = navigationController?.popViewController(animated: true)

    
    }
    
    
    @IBAction func scrubMoved(_ sender: Any) {
        
        SoundPlayer.pause()
        SoundPlayer.currentTime = TimeInterval(scrubber.value)
        SoundPlayer.play()
        
    }
    
    @IBAction func backTapped(_ sender: Any) {
        scrubber.value = scrubber.value - 3;
        SoundPlayer.currentTime = TimeInterval(scrubber.value)

    }
    
    @IBAction func skipTapped(_ sender: Any) {
        
        scrubber.value = scrubber.value + 3;
        SoundPlayer.currentTime = TimeInterval(scrubber.value)
    }
    
    func preparePlayer(){
        
        do {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch {
                
            }
            
            if (translate) {
                try SoundPlayer = AVAudioPlayer(data: translation.audio! as Data)
            } else {
                try SoundPlayer = AVAudioPlayer(data: transcript.audio! as Data)
            }
            SoundPlayer.delegate = self as AVAudioPlayerDelegate
            SoundPlayer.prepareToPlay()
            SoundPlayer.volume = 1.0
        } catch {
            print("Error playing")
        }
        
    }
    
    @IBAction func playTapped(_ sender: Any) {
        if (!SoundPlayer.isPlaying) {
            
            playButton.setImage(UIImage(named:"PAUSE.png"), for: .normal);
            playButton.imageEdgeInsets = UIEdgeInsets(top: 30, left: 25, bottom: 30, right: 25)

            
        SoundPlayer.play()
        timer = Timer.scheduledTimer(withTimeInterval: 0.001, repeats: true, block: {_ in
            let currentTime = Int(self.SoundPlayer.currentTime)
            let minutes = currentTime / 60
            let seconds = currentTime - minutes * 60
            self.leftLabel.text = String(format: "%02i:%02i", minutes, (seconds))
            self.scrubber.value = Float(self.SoundPlayer.currentTime)
        }) } else {
            SoundPlayer.pause()
            playButton.setImage(UIImage(named:"PLAY.png"), for: .normal);
            playButton.imageEdgeInsets = UIEdgeInsets(top: 30, left: 25, bottom: 30, right: 25)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationItem.setHidesBackButton(true, animated:true);
        if (transcript != nil) {
             titleTextField.text = transcript.name;
            textView.isHidden = false;
            textView.text = transcript.text;
            leftText.isHidden = true;
            rightText.isHidden = true;
            fromLabel.isHidden = true;
            toLabel.isHidden = true;
        } else {
             titleTextField.text = translation.name;
            translate = true;
            leftText.isHidden = false;
            rightText.isHidden = false;
            fromLabel.isHidden = false;
            toLabel.isHidden = false;
            leftText.text = translation.text;
            rightText.text = translation.translation;
            textView.isHidden = true;

        }
        preparePlayer()
        scrubber.value = 0
        scrubber.maximumValue = Float(SoundPlayer.duration)
        let max = Int(scrubber.maximumValue)
        let minutes =  max / 60 / 3;
        let seconds = max - minutes * 60;
        print(minutes, seconds)
        self.rightLabel.text = String(format: "%02i:%02i", minutes, seconds)
        scrubber.minimumTrackTintColor = UIColor(red:0.24, green:0.26, blue:0.38, alpha:1)
        
        
        //TEXTLEFT
        let yeye=UIView(frame: CGRect(x: 20, y: 205, width: self.view.bounds.width - 225, height: 425))
        yeye.backgroundColor=UIColor.white
        yeye.layer.cornerRadius=0
        yeye.clipsToBounds = false
        yeye.layer.shadowOpacity=0.1
        yeye.layer.shadowOffset = CGSize(width:3, height:3)
        
        self.view.addSubview(yeye)
        self.view.sendSubview(toBack: yeye)
        
        //PICKERS
        let myNewView=UIView(frame: CGRect(x: 20, y: 80, width: self.view.bounds.width - 40, height: 105))
        myNewView.backgroundColor=UIColor.white
        myNewView.layer.cornerRadius=0
        myNewView.clipsToBounds = false
        myNewView.layer.shadowOpacity=0.1
        myNewView.layer.shadowOffset = CGSize(width:3, height:3)
        self.view.addSubview(myNewView)
        self.view.sendSubview(toBack: myNewView)
        
        //TEXTRIGHT
        let yoyo=UIView(frame: CGRect(x: (self.view.bounds.width - 20) - (self.view.bounds.width - 225), y: 205, width: self.view.bounds.width - 225, height: 425))
        yoyo.backgroundColor=UIColor.white
        yoyo.layer.cornerRadius=0
        yoyo.clipsToBounds = false
        yoyo.layer.shadowOpacity=0.1
        yoyo.layer.shadowOffset = CGSize(width:3, height:3)
        self.view.addSubview(yoyo)
        self.view.sendSubview(toBack: yoyo)
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
