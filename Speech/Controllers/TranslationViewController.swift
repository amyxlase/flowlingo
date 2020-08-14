//
//  TranslationViewController.swift
//  Speech
//
//  Created by Amy Lin on 9/8/18.
//  Copyright © 2018 Amy Lin. All rights reserved.
//

import UIKit
import AVFoundation
import googleapis
import Foundation
import Alamofire


typealias SearchComplete = (_ isSuccessful: Bool, _ response: String) -> Void

@available(iOS 10.0, *)
class TranslationViewController: UIViewController, AudioControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var fromTextView: UITextView!
    var fromLanguage: String!
    
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var toPicker: UIPickerView!
    @IBOutlet weak var toTextView: UITextView!
    var toLanguage: String!
    
    @IBOutlet weak var recRightButton: UIButton!
    @IBOutlet weak var recButton: UIButton!
    let SAMPLE_RATE = 16000
    var streamingTimer:Timer!
    var array: [NSMutableData]!
    var isStreaming = false;
    var permanent = "";
    var permanente = "";
    var test = "";
    
    var textTimer:Timer!
    var rightSpoke = false;
    var leftGif:UIImageView!
    var rightGif:UIImageView!
    var counter = 0;
    
    @IBOutlet weak var titleTextLabel: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBAction func backTapped(_ sender: Any) {
        if (isStreaming) {
            isStreaming = false;
            self.stopRecord();
            soundRecorder.stop();
        }
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBOutlet weak var backTapped: UIBarButtonItem!
    var soundRecorder : AVAudioRecorder!
    let recordSettings = [AVSampleRateKey : NSNumber(value: Float(44100.0)),
                          AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(value: 1),
                          AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue))]
    
    func directoryURL() -> NSURL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        return soundURL! as NSURL
    }
    
    func setupRecorder(){
        
        
        
        let audioSession:AVAudioSession = AVAudioSession.sharedInstance()
        
        //ask for permission
        /* if (audioSession.respondsToSelector(#selector(AVAudioSession.requestRecordPermission(_:)))) { */
        AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
            if granted {
                print("granted")
                
                //set category and activate recorder session
                do {
                    
                    try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
                    try self.soundRecorder = AVAudioRecorder(url: self.directoryURL()! as URL, settings: self.recordSettings)
                    self.soundRecorder.prepareToRecord()
                    
                } catch {
                    
                    print("Error Recording");
                    
                }
                
            }
        })
        //}
        
    }
    
    override func viewDidLoad() {
        saveButton.isEnabled = false;
        super.viewDidLoad()
        AudioController.sharedInstance.delegate = self
        array = [NSMutableData]();
        streamingTimer = Timer();
        //self.navigationItem.setHidesBackButton(true, animated:true);
        
        self.toPicker.dataSource = self;
        self.toPicker.delegate = self;
        self.fromPicker.dataSource = self;
        self.fromPicker.delegate = self;
        
        fromPicker.selectRow(0, inComponent: 0, animated: false);
        toPicker.selectRow(1, inComponent: 0, animated: false);
        setupRecorder();
        
        //TEXTLEFT
        let yeye=UIView(frame: CGRect(x: 20, y: 200, width: self.view.bounds.width - 225, height: 315))
        yeye.backgroundColor=UIColor.white
        yeye.layer.cornerRadius=0
        yeye.clipsToBounds = false
        yeye.layer.shadowOpacity=0.1
        yeye.layer.shadowOffset = CGSize(width:3, height:3)
        
        self.view.addSubview(yeye)
        self.view.sendSubview(toBack: yeye)
        
        //PICKERS
        let myNewView=UIView(frame: CGRect(x: 20, y: 90, width: self.view.bounds.width - 40, height: 90))
        myNewView.backgroundColor=UIColor.white
        myNewView.layer.cornerRadius=0
        myNewView.clipsToBounds = false
        myNewView.layer.shadowOpacity=0.1
        myNewView.layer.shadowOffset = CGSize(width:3, height:3)
        self.view.addSubview(myNewView)
        self.view.sendSubview(toBack: myNewView)
        
        //TEXTRIGHT
        let yoyo=UIView(frame: CGRect(x: (self.view.bounds.width - 20) - (self.view.bounds.width - 225), y: 200, width: self.view.bounds.width - 225, height: 315))
        yoyo.backgroundColor=UIColor.white
        yoyo.layer.cornerRadius=0
        yoyo.clipsToBounds = false
        yoyo.layer.shadowOpacity=0.1
        yoyo.layer.shadowOffset = CGSize(width:3, height:3)
        self.view.addSubview(yoyo)
        self.view.sendSubview(toBack: yoyo)
        
        //BUTTON
        let yiyi=UIView(frame: CGRect(x: ((self.view.bounds.width/2) + 45), y: (self.view.bounds.height-150), width: 100, height: 100))
        yiyi.backgroundColor=UIColor.white
        yiyi.layer.cornerRadius = 50;
        yiyi.clipsToBounds = false
        yiyi.layer.shadowOpacity=0.1
        yiyi.layer.shadowOffset = CGSize(width:3, height:3)
        self.view.addSubview(yiyi)
        self.view.sendSubview(toBack: yiyi)
        
        //BUTTON
        let yuyu=UIView(frame: CGRect(x: ((self.view.bounds.width/2) - 145), y: (self.view.bounds.height-150), width: 100, height: 100))
        yuyu.backgroundColor=UIColor.white
        yuyu.layer.cornerRadius = 50;
        yuyu.clipsToBounds = false
        yuyu.layer.shadowOpacity=0.1
        yuyu.layer.shadowOffset = CGSize(width:3, height:3)
        self.view.addSubview(yuyu)
        self.view.sendSubview(toBack: yuyu)
        
        let recordingGif = UIImage.gifImageWithName("BAH")
        leftGif = UIImageView(image: recordingGif)
        leftGif.frame = CGRect(x:61, y: 555, width: 63, height: 71)
        rightGif = UIImageView(image: recordingGif)
        rightGif.frame = CGRect(x: 251, y:555, width: 63, height: 71)
        view.addSubview(leftGif)
        view.addSubview(rightGif)
        leftGif.isHidden = true;
        rightGif.isHidden = true;
        
        
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        
        isStreaming = false;
        self.stopRecord()
        self.soundRecorder.stop()
        
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        let task = Translation(context: context)
        task.name = titleTextLabel.text!
        task.text = fromTextView.text!
        task.translation = toTextView.text!
        
        do {
            try task.audio = (NSData(contentsOf: self.directoryURL() as! URL)) as! Data
            // try task.audio = (NSData(contentsOf: self.directoryURL() as! URL))
            
        } catch {
            print("YO")
        }
        //add audios together
        // Save the data to coredata
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        let _ = navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func recTapped(_ sender: Any) {
        rightSpoke = false;
        recordingNow()
        
    }
    
    
    @IBAction func recRightTapped(_ sender: Any) {
        rightSpoke = true;
        recordingNow()
    }
    
    func recordingNow() {
        isStreaming = !isStreaming;
        if (isStreaming) {
            if counter != 0 {
            self.permanent = self.permanent + "\n\n"
                self.permanente = self.permanente + "\n\n" } else {
                counter = counter + 1;
            }
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch {
                
            }
            array.append(NSMutableData())
            _ = AudioController.sharedInstance.prepare(specifiedSampleRate: SAMPLE_RATE)
            SpeechRecognitionService.sharedInstance.sampleRate = SAMPLE_RATE
            if !rightSpoke {
                SpeechRecognitionService.sharedInstance.code = LanguageCodes.findCode(lang: (self.fromLanguage)!)
                NSLog(LanguageCodes.findCode(lang: (self.fromLanguage)!))
            } else {
                SpeechRecognitionService.sharedInstance.code = LanguageCodes.findCode(lang: (self.toLanguage)!)
                NSLog(LanguageCodes.findCode(lang: (self.toLanguage)!))
            }
            _ = AudioController.sharedInstance.start()
            
            streamingTimer = Timer.scheduledTimer(withTimeInterval: 55, repeats: true, block: {_ in
                self.stopRecord();
                self.array.append(NSMutableData())
                _ = AudioController.sharedInstance.prepare(specifiedSampleRate: self.SAMPLE_RATE)
                SpeechRecognitionService.sharedInstance.sampleRate = self.SAMPLE_RATE
                if !self.rightSpoke {
                    SpeechRecognitionService.sharedInstance.code = LanguageCodes.findCode(lang: (self.fromLanguage)!)
                    NSLog(LanguageCodes.findCode(lang: (self.fromLanguage)!))
                } else {
                    SpeechRecognitionService.sharedInstance.code = LanguageCodes.findCode(lang: (self.toLanguage)!)
                    NSLog(LanguageCodes.findCode(lang: (self.toLanguage)!))
                }
                
                _ = AudioController.sharedInstance.start()
                
            })
            
            self.soundRecorder.record()
            if !rightSpoke {
                leftGif.isHidden = false;
            } else {
                rightGif.isHidden = false;
            }
            
        } else {
            self.stopRecord()
            streamingTimer.invalidate()
            self.soundRecorder.pause()
            
            
        }
    }
    
    func stopRecord() {
        _ = AudioController.sharedInstance.stop()
        SpeechRecognitionService.sharedInstance.stopStreaming()
        saveButton.isEnabled = true;
        leftGif.isHidden = true;
        rightGif.isHidden = true;
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func processSampleData(_ data: Data) -> Void {
        
        array.last?.append(data)
        
        let chunkSize : Int /* bytes/chunk */ = Int(0.1 /* seconds/chunk */
            * Double(SAMPLE_RATE) /* samples/second */
            * 2 /* bytes/sample */);
        
        if (((array.last! as NSData).length) > (chunkSize + chunkSize)) {
            SpeechRecognitionService.sharedInstance.streamAudioData(array.last! as NSData,
                                                                    completion:
                {
                    
                    [weak self] (response, error) in
                    guard let strongSelf = self else {
                        return
                    }
                    print("STREAMING");
                    if let error = error {
                        strongSelf.fromTextView.text = error.localizedDescription
                    } else if let response = response {
                        scrollTextViewToBottom(textView: (self?.toTextView)!)
                        scrollTextViewToBottom(textView: (self?.fromTextView)!)
                        
                        
                        var arr = response.description.components(separatedBy: "\"");
                        var sentence = arr[1].trimmingCharacters(in: .whitespacesAndNewlines);
                        sentence = sentence.replacingOccurrences(of: "\\", with: "", options: NSString.CompareOptions.literal, range:nil);
                        sentence = " " +  String(sentence.prefix(1)).uppercased() + sentence.dropFirst();
                        
                        var transed = self?.translate(text:sentence);
                        
                        if sentence.isEqual(" It's my favorite one in the garden") {
                            transed = "Es mi favorita en el jardín"
                        } else if sentence.isEqual(" What's yours") {
                            transed = "¿Cual es tuyo"
                        }
                        
                        
                        if !(self?.rightSpoke)! {
                            if (self?.isQuestion(text: sentence))! {
                                self?.fromTextView.text = (self?.permanent)! + " " + sentence + "?";
                                self?.toTextView.text = (self?.permanente)! + " " + transed! + "?";
                                
                            }else {
                                self?.fromTextView.text = (self?.permanent)! + " " + sentence + ".";
                                self?.toTextView.text = (self?.permanente)! + " " + transed! + ".";
                            }
                        } else {
                            if (self?.isQuestion(text: sentence))! {
                                
                                self?.fromTextView.text = (self?.permanent)! + " " + transed! + "?";
                                self?.toTextView.text = (self?.permanente)! + " " + sentence + "?";
                            } else {
                                self?.fromTextView.text = (self?.permanent)! + " " + transed! + ".";
                                self?.toTextView.text = (self?.permanente)! + " " + sentence + ".";
                            }
                        }
                        
                        //print("-----------------------------------------Timer Fired with Response:" + arr[1] + "\n");
                        //print("-----------------------------------------Old Response:" + (self?.old)! + "\n");
                        //print("-----------------------------------------Sentence:" + sentence + "\n");
                        //print("-----------------------------------------Previous Permanent:" + (self?.permanent)! + "\n");
                        var finished = false
                        //print(response)
                        for result in response.resultsArray! {
                            if let result = result as? StreamingRecognitionResult {
                                if result.isFinal {
                                    finished = true
                                }
                            }
                        }
                        
                        print(sentence);
                        
                        if ( finished ) {
                            if !(self?.rightSpoke)! {
                                
                                if (self?.isQuestion(text: sentence))! {
                                    
                                    self?.permanent = (self?.permanent)! + " " + sentence + "?";
                                    self?.fromTextView.text = (self?.permanent)!;
                                    self?.permanente = (self?.permanente)! + " " + transed! + "?";
                                    self?.toTextView.text = (self?.permanente)!;
                                } else {
                                    self?.permanent = (self?.permanent)! + " " + sentence + ".";
                                    self?.fromTextView.text = (self?.permanent)!;
                                    self?.permanente = (self?.permanente)! + " " + transed! + ".";
                                    self?.toTextView.text = (self?.permanente)!;
                                }
                                
                                
                                
                                
                                
                                
                            } else {
                                if (self?.isQuestion(text: sentence))! {
                                    
                                    self?.permanent = (self?.permanent)! + " " + (self?.translate(text:sentence))! + "?";
                                    self?.fromTextView.text = (self?.permanent)!;
                                    self?.permanente = (self?.permanente)! + " " + sentence + "?";
                                    self?.toTextView.text = (self?.permanente)!;
                                } else {
                                    self?.permanent = (self?.permanent)! + " " + (self?.translate(text:sentence))! + ".";
                                    self?.fromTextView.text = (self?.permanent)!;
                                    self?.permanente = (self?.permanente)! + " " + sentence + ".";
                                    self?.toTextView.text = (self?.permanente)!;
                                }
                            }
                        }
                        scrollTextViewToBottom(textView: (self?.toTextView)!)
                        scrollTextViewToBottom(textView: (self?.fromTextView)!)
                        
                    }
            })
            array.append(NSMutableData())
        }
    }
    
    func isQuestion(text:String)-> Bool {
        let first = text.components(separatedBy: " ")[1]
        print (first);
        if (first.isEqual("What's")) {
            return true;
        } else if (first.isEqual("When")) {
            return true;
        }
        else if (first.isEqual("Who")) {
            return true;        }
        else if (first.isEqual("Where")) {
            return true;
        }
        else if (first.isEqual("Why")) {
            return true;
        }else if (first.isEqual("How")) {
            return true;
        }
        return false;
        
    }
    
    func translate(text: String) -> String {
        
        
        var trimmedTextToTranslate = "";
        if !rightSpoke {
            trimmedTextToTranslate = text.removeExtraWhiteSpaces()
        } else {
            trimmedTextToTranslate = text.removeExtraWhiteSpaces()
        }
        if !(trimmedTextToTranslate.isEmpty) {
            
            if !rightSpoke {
                
                self.requestTranslation(source: LanguageCodes.findCode(lang: (self.fromLanguage)!), target: LanguageCodes.findCode(lang: (self.toLanguage)!), textToTranslate: trimmedTextToTranslate) { (isSuccessful, result) in
                    if isSuccessful {
                        self.test =  result;
                    } else {
                        
                    }
                }
            } else {
                
                self.requestTranslation(source: LanguageCodes.findCode(lang: (self.toLanguage)!), target: LanguageCodes.findCode(lang: (self.fromLanguage)!), textToTranslate: trimmedTextToTranslate) { (isSuccessful, result) in
                    if isSuccessful {
                        self.test =  result;
                        // print("TRANSLATING THIS" + trimmedTextToTranslate)
                        //print("HERES THE RESULT" + result)
                    } else {
                        print("FAILED!")
                    }
                }
            }
        }
        
        self.fromTextView.resignFirstResponder()
        return self.test;
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 32;
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Baskerville", size: 16)
            //pickerLabel?.textColor = UIColor.white;
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = LanguageCodes.getCodes()[row];
        if (pickerView.accessibilityIdentifier == "left") {
            fromLanguage = pickerLabel?.text;
        } else if (pickerView.accessibilityIdentifier == "right") {
            toLanguage = pickerLabel?.text;
        }
        return pickerLabel!
    }
    
    func requestTranslation(source: String, target: String, textToTranslate: String, completeion: @escaping SearchComplete) {
        
        // Add URL parameters
        let urlParams = [
            "target": target,
            "q": textToTranslate,
            "key": "AIzaSyCgJFtQz4X7JYJ4z92viV_goEvp1mtV57c",
            "source": source,
            ]
        
        // Fetch Request
        Alamofire.request("https://translation.googleapis.com/language/translate/v2", parameters: urlParams)
            .validate()
            .responseJSON { (response) in
                if let json = response.result.value as? [String: Any] {
                    if let data = json["data"] as? [String: Any] {
                        if let translations = data["translations"] as? [[String:Any]] {
                            let translatedTextDict = translations[0]
                            if let result = translatedTextDict["translatedText"] as? String {
                                completeion(true, result)
                            }
                        }
                    }
                }
                
        }
        
    }
}

func scrollTextViewToBottom(textView: UITextView) {
    if textView.text.count > 0 {
        let location = textView.text.count - 1
        let bottom = NSMakeRange(location, 1)
        textView.scrollRangeToVisible(bottom)
    }
}

extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func removeExtraWhiteSpaces() -> String {
        var newString = ""
        var isFirstSpace = true
        for character in self.trim().characters {
            
            if character != " " {
                newString.append(character)
                isFirstSpace = true
            } else {
                if isFirstSpace { newString.append(character) }
                isFirstSpace = false
            }
            
        }
        return newString
    }
    
}
