//
//  LanguageCodes.swift
//  Speech
//
//  Created by Amy Lin on 9/8/18.
//  Copyright © 2018 Amy Lin. All rights reserved.
//

import Foundation

class LanguageCodes: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    let codes = [["Afrikaans", "af"], ["Albanian", "sq"], ["Amharic", "am"], ["Arabic", "ar"], ["Armenian", "hy"], ["Azeerbaijani", "az"], ["Basque", "eu"], ["Belarusian", "be"], ["Bengali", "bn"], ["Bosnian", "bs"], ["Bulgarian", "bg"], ["Catalan", "ca"], ["Cebuano", "ceb"], ["Chinese (Simplified)", "zh-CN"], ["Chinese (Traditional)", "zh-TW"], ["Corsican", "co"], ["Croatian", "hr"], ["Czech", "cs"], ["Danish", "da"], ["Dutch", "nl"], ["English", "en"], ["Esperanto", "eo"], ["Estonian", "et"], ["Finnish", "fi"], ["French", "fr"], ["Frisian", "fy"], ["Galician", "gl"], ["Georgian", "ka"], ["German", "de"], ["Greek", "el"], ["Gujarati", "gu"], ["Haitian Creole", "ht"], ["Hausa", "ha"], ["Hawaiian", "haw"], ["Hebrew", "he"], ["Hindi", "hi"], ["Hmong", "hmn"], ["Hungarian", "hu"], ["Icelandic", "is"], ["Igbo", "ig"], ["Indonesian", "id"], ["Irish", "ga"], ["Italian", "it"], ["Japanese", "ja"], ["Javanese", "jw"], ["Kannada", "kn"], ["Kazakh", "kk"], ["Khmer", "km"], ["Korean", "ko"], ["Kurdish", "ku"], ["Kyrgyz", "ky"], ["Lao", "lo"], ["Latin", "la"], ["Latvian", "lv"], ["Lithuanian", "lt"], ["Luxembourgish", "lb"], ["Macedonian", "mk"], ["Malagasy", "mg"], ["Malay", "ms"], ["Malayalam", "ml"], ["Maltese", "mt"], ["Maori", "mi"], ["Marathi", "mr"], ["Mongolian", "mn"], ["Myanmar (Burmese)", "my"], ["Nepali", "ne"], ["Norwegian", "no"], ["Nyanja (Chichewa)", "ny"], ["Pashto", "ps"], ["Persian", "fa"], ["Polish", "pl"], ["Portuguese (Portugal, Brazil)", "pt"], ["Punjabi", "pa"], ["Romanian", "ro"], ["Russian", "ru"], ["Samoan", "sm"], ["Scots Gaelic", "gd"], ["Serbian", "sr"], ["Sesotho", "st"], ["Shona", "sn"], ["Sindhi", "sd"], ["Sinhala (Sinhalese)", "si"], ["Slovak", "sk"], ["Slovenian", "sl"], ["Somali", "so"], ["Spanish", "es"], ["Sundanese", "su"], ["Swahili", "sw"], ["Swedish", "sv"], ["Tagalog (Filipino)", "tl"], ["Tajik", "tg"], ["Tamil", "ta"], ["Telugu", "te"], ["Thai", "th"], ["Turkish", "tr"], ["Ukrainian", "uk"], ["Urdu", "ur"], ["Uzbek", "uz"], ["Vietnamese", "vi"], ["Welsh", "cy"], ["Xhosa", "xh"], ["Yiddish", "yi"], ["Yoruba", "yo"], ["Zulu", "zu"]];

    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 104;
    }
}
