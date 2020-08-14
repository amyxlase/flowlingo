//
//  DictationViewController.swift
//  Speech
//
//  Created by Amy Lin on 9/22/18.
//  Copyright © 2018 Amy Lin. All rights reserved.
//

import UIKit
import Alamofire

class DictationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    @IBOutlet weak var speakButton: UIButton!
    var imageView:UIImageView!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var textVIew: UITextView!
    var fromLanguage = "";
    var toLanguage = "";
    var translation = "";
    
    @IBAction func backTapped(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.accessibilityIdentifier == "L") {
            return 32;
        } else if (pickerView.accessibilityIdentifier == "R") {
            return 8;
        }
        return -1;
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        var placeholder: UILabel? = (view as? UILabel)
        
        if (pickerView.accessibilityIdentifier == "L") {
            var pickerLabel1: UILabel? = (view as? UILabel)
            if pickerLabel1 == nil {
                pickerLabel1 = UILabel()
                pickerLabel1?.font = UIFont(name: "Baskerville", size: 16)
                pickerLabel1?.textAlignment = .center
            }
            pickerLabel1?.text = LanguageCodes.getCodes()[row];
            fromLanguage = (pickerLabel1?.text)!;
            placeholder = pickerLabel1;
        } else if (pickerView.accessibilityIdentifier == "R") {
            var pickerLabel2: UILabel? = (view as? UILabel)
            if pickerLabel2 == nil {
                pickerLabel2 = UILabel()
                pickerLabel2?.font = UIFont(name: "Baskerville", size: 16)
                pickerLabel2?.textAlignment = .center
            }
            pickerLabel2?.text = LanguageCodes.getVoices()[row];
            toLanguage = (pickerLabel2?.text)!;
            placeholder = pickerLabel2;
        }
        return placeholder!
    }
    
    @IBAction func speakPressed(_ sender: Any) {
        
        let recordingGif = UIImage.gifImageWithName("cats")
        imageView = UIImageView(image: recordingGif)
        imageView.frame = CGRect(x: 150, y: 535, width: self.view.frame.size.width - 300, height: 80)
        view.addSubview(imageView)

        speakButton.alpha = 0;
        
        if (toLanguage == fromLanguage) {
            SpeechService.shared.speak(text: self.textVIew.text, voiceType: LanguageCodes.findVoice(lang: self.toLanguage)) {
                self.imageView.isHidden = true;
                self.speakButton.alpha = 1;
            }
        }else {
        
        self.translate(text:textVIew.text);
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.toPicker.dataSource = self;
        self.toPicker.delegate = self;
        self.fromPicker.dataSource = self;
        self.fromPicker.delegate = self;
        self.toPicker.selectRow(1, inComponent: 0, animated: false);

    

        
        let yeye=UIView(frame: CGRect(x: 20, y: 170, width: self.view.bounds.width - 40, height: 230))
        yeye.backgroundColor=UIColor.white
        yeye.layer.cornerRadius=0
        yeye.clipsToBounds = false
        yeye.layer.shadowOpacity=0.1
        yeye.layer.shadowOffset = CGSize(width:3, height:3)
        
        // Add UIView as a Subview
        self.view.addSubview(yeye)
        self.view.sendSubview(toBack: yeye)
        
        let myNewView=UIView(frame: CGRect(x: 20, y: 90, width: self.view.bounds.width - 40, height: 57))
        myNewView.backgroundColor=UIColor.white
        myNewView.layer.cornerRadius=0
        myNewView.clipsToBounds = false
        myNewView.layer.shadowOpacity=0.1
        myNewView.layer.shadowOffset = CGSize(width:3, height:3)
        
        // Add UIView as a Subview
        self.view.addSubview(myNewView)
        self.view.sendSubview(toBack: myNewView)
        
        let yoyo=UIView(frame: CGRect(x: 20, y: 435, width: self.view.bounds.width - 40, height: 57))
        yoyo.backgroundColor=UIColor.white
        yoyo.layer.cornerRadius=0
        yoyo.clipsToBounds = false
        yoyo.layer.shadowOpacity=0.1
        yoyo.layer.shadowOffset = CGSize(width:3, height:3)
        
        // Add UIView as a Subview
        self.view.insertSubview(yoyo, belowSubview:textVIew)
        
        let yiyi=UIView(frame: CGRect(x: ((self.view.bounds.width/2) - 50), y: 525, width: 100, height: 100))
        yiyi.backgroundColor=UIColor.white
        yiyi.layer.cornerRadius = 50;
        yiyi.clipsToBounds = false
        yiyi.layer.shadowOpacity=0.1
        yiyi.layer.shadowOffset = CGSize(width:3, height:3)
        
        // Add UIView as a Subview
        self.view.insertSubview(yiyi, belowSubview:textVIew)
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func translate(text: String) {

        let trimmedTextToTranslate = self.textVIew.text.removeExtraWhiteSpaces()
        print(trimmedTextToTranslate)

        if !(trimmedTextToTranslate.isEmpty) {
            self.requestTranslation(source: LanguageCodes.findCode(lang: (self.fromLanguage)), target: LanguageCodes.findCode(lang: (self.toLanguage)), textToTranslate: trimmedTextToTranslate) { (isSuccessful, result) in
                if isSuccessful {
                    SpeechService.shared.speak(text: result, voiceType: LanguageCodes.findVoice(lang: self.toLanguage)) {
                        self.speakButton.setTitle("Speak", for: .normal)
                        self.speakButton.isEnabled = true
                        self.speakButton.alpha = 1
                        self.imageView.isHidden = true;
                    }
                } else {
                }
            }
        }
        
        self.textVIew.resignFirstResponder()
        
        
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
