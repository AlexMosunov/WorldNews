//
//  AlamofireNetworkRequest.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String, page: Int, completion: @escaping (_ result: Result<[ArticleModel], Error>)->()) {

            let newurl = "\(url)&page=\(page)"
            print("URL - \(newurl)")
            
            guard let url = URL(string: newurl) else { return }
            AF.request(url, method: .get).validate().responseJSON { (response) in
                
                switch response.result {
                    
                case .success(let value):
                    let articlesArray = ArticleModel.getArray(from: value) ?? []
                    completion(.success(articlesArray))
             
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
            
        }
    
    static func sendRequestForSources(url: String, completion: @escaping (_ result: Result<[String], Error>)->()) {
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .get).validate().responseJSON { (response) in
            
            switch response.result {
                
            case .success(let value):
                guard let json = value as? JSON else { return }
                guard let sources = json["sources"] as? Array<JSON> else { return }
                let sourcesIds = sources.map{ $0["id"] } as? [String]
                if sourcesIds != nil {
                    completion(.success(sourcesIds!))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private static func getUrlWith(apiKey: String,
                           category: String? = nil,
                           language: String? = nil,
                           country: String? = nil,
                           pageSize: Int,
                           page: Int? = 1) -> String {

        let categoryPath = (category != nil) ? Constants.categoryInfo + category! : ""
        let languagePath = (language != nil) ? Constants.languageInfo + language! : ""
        let countryPath = (country != nil) ? Constants.countryInfo + country! : ""
       
        let apiKeyPath = Constants.apiKeyInfo + apiKey
        
        return Constants.newsApiBaseUrl + apiKeyPath + categoryPath + languagePath + countryPath + "&pageSize=\(pageSize)"
    }
}
