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
        guard let urlString = article.urlToImage else { return nil }
        return URL(string: urlString)
    }
    
    var sourceUrlString: String? {
        return article.url
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
