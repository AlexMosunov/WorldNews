//
//  ArticleCellViewModel.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import Foundation

struct ArticleCellViewModel {
    private let article: ArticleModel
    
    var articleTitle: String {
        return article.title ?? ""
    }
    
    var urlToImage: URL? {
        return URL(string: article.urlToImage ?? "")
    }
    
    var articleDescription: String {
        return article.description ?? ""
    }
    
    var articleAuthor: String {
        return article.author ?? "Nicholas Cage"
    }
    
    var articleSource: String {
        return article.sourceName ?? "Bloomber business"
    }

    
    init(article: ArticleModel) {
        self.article = article
    }
    
}
