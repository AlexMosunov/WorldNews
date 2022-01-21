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
    static let sourceInfo = "&source="
    
    
    static let pageInfo = "&page="
    static let apiKeyInfo = "apiKey="
    static let pageSizeInfo = "&pageSize="
    
    
    static func getUrlWith(apiKey: String,
                           category: String? = nil,
                           language: String? = nil,
                           country: String? = nil,
                           source: String? = nil,
                           pageSize: Int,
                           page: Int? = 1) -> String {

        
        let categoryPath = (category != nil) ? categoryInfo + category! : ""
        let languagePath = (language != nil) ? languageInfo + language! : ""
        let countryPath = (country != nil) ? countryInfo + country! : ""
        let sourcePath = (source != nil) ? sourceInfo + source! : ""
       
        let apiKeyPath = apiKeyInfo + apiKey
        let pageSizePath = pageSizeInfo + String(pageSize)
        
        return newsApiBaseUrl + apiKeyPath + categoryPath + languagePath + countryPath + sourcePath + pageSizePath
    }
}
