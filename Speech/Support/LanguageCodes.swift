//
//  LanguageCodes.swift
//  Speech
//
//  Created by Amy Lin on 9/11/18.
//  Copyright © 2018 Amy Lin. All rights reserved.
//

import Foundation

struct LanguageCodes {
    
    static func getCodes() -> [String] {
        return ["English", "Spanish", "Chinese (Simplified)", "Chinese (Traditional)", "Tagalog", "Vietnamese", "Arabic", "French", "Korean", "Russian", "German", "Haitian", "Hindi", "Portuguese", "Italian", "Polish", "Urdu", "Japanese", "Persian", "Gujarati", "Telugu", "Bengali", "Tai–Kadai", "Greek", "Punjabi", "Tamil", "Armenian", "Serbo-Croatian", "Hebrew", "Hmong", "Bantu", "Khmer"];

    }
    
    static func findCode(lang:String) -> String {
        let countries = ["English", "Spanish", "Chinese (Simplified)", "Chinese (Traditional)", "Tagalog", "Vietnamese", "Arabic", "French", "Korean", "Russian", "German", "Haitian", "Hindi", "Portuguese", "Italian", "Polish", "Urdu", "Japanese", "Persian", "Gujarati", "Telugu", "Bengali", "Tai–Kadai", "Greek", "Punjabi", "Tamil", "Armenian", "Serbo-Croatian", "Hebrew", "Hmong", "Bantu", "Khmer"];
        let codes = ["en", "es", "zh-CN", "zh-TW", "tl", "vi", "ar", "fr", "ko", "ru", "de", "ht", "hi", "pt", "it", "pl", "ur", "ja", "fa", "gu", "te", "be", "el", "pg", "ta", "hy", "he", "hmn", "km"];

        let n = countries.index(of:lang);
        return codes[n!];
    }
    
    static func getVoices() -> [String] {
        return ["English", "Spanish", "French", "Korean", "German", "Portuguese", "Italian", "Japanese"];
    }
    
    static func findVoice(lang:String) -> String {
        let languages = ["English", "Spanish", "French", "Korean", "German", "Portuguese", "Italian", "Japanese"];
        let voices = ["en-US-Wavenet-C", "es-ES-Standard-A", "fr-FR-Wavenet-A", "ko-KR-Wavenet-A", "de-DE-Wavenet-A", "pt-BR-Standard-A", "it-IT-Wavenet-A", "ja-JP-Wavenet-A"];
        let n = languages.index(of:lang);
        return voices[n!];
    }
    
}
