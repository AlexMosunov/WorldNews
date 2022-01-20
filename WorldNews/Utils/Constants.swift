//
//  Constants.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//


let API_KEY = "d7ae831b5c654b2bbee290b51935c35b"

struct Constants {
    static let newsApiBaseUrl = "https://newsapi.org/v2/top-headlines?"
    static let categoryInfo = "&category="
    static let languageInfo = "&language="
    static let countryInfo = "&country="
    static let apiKeyInfo = "apiKey="
    
    
    static func getUrlWith(apiKey: String,
                           category: String? = nil,
                           language: String? = nil,
                           country: String? = nil) -> String {
        let categoryPath = (category != nil) ? categoryInfo + category! : ""
        let languagePath = (language != nil) ? languageInfo + language! : ""
        let countryPath = (country != nil) ? countryInfo + country! : ""
        let apiKeyPath = apiKeyInfo + apiKey
        
        return newsApiBaseUrl + apiKeyPath + categoryPath + languagePath + countryPath
    }
}
