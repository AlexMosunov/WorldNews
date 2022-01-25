//
//  NewsData.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import Foundation

typealias JSON = [String : Any]

struct ArticleModel {
    let author: String?
    let title: String?
    let description: String?
    let urlToImage: String?
    let sourceName: String?
    let url: String?
    let publishedAt: Date?
    
    
    init?(json: JSON) {
        let author = json["author"] as? String
        let title = json["title"] as? String
        let description = json["description"] as? String
        let urlToImage = json["urlToImage"] as? String
        let source = json["source"] as? JSON
        let sourceName = source?["name"] as? String
        let url = json["url"] as? String
        let publishedAt = json["publishedAt"] as? Date
        
        self.author = author
        self.title = title
        self.description = description
        self.urlToImage = urlToImage
        self.sourceName = sourceName
        self.url = url
        self.publishedAt = publishedAt
    }
    
    init(favouriteArticle: Article) {
        self.author = favouriteArticle.author
        self.title = favouriteArticle.title
        self.description = favouriteArticle.articleDescription
        self.urlToImage = favouriteArticle.urlToImage
        self.sourceName = favouriteArticle.sourceName
        self.url = favouriteArticle.sourceUrl
        self.publishedAt = favouriteArticle.publishedAt
    }
    
    static var totalResults = 0
    
    static func getArray(from json: Any) -> [ArticleModel]? {
        guard let json = json as? JSON else { return nil }
        guard let articles = json["articles"] as? Array<JSON> else { return nil}
        totalResults = json["totalResults"] as? Int ?? 0
        return articles.compactMap { ArticleModel(json: $0) }
        
    }
}
