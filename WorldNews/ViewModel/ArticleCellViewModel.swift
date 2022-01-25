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
    
    var urlToImageString: String? {
        return article.urlToImage ?? ""
    }
    
    var sourceUrlString: String? {
        return article.url
    }
    
    var articleDescription: String {
        return article.description ?? ""
    }
    
    var articleAuthor: String {
        return article.author ?? ""
    }
    
    var articleSource: String {
        return article.sourceName ?? ""
    }
    
    var publishedAt: Date {
        return article.publishedAt ?? Date()
    }
    
    func initializeCoreDataEntity(_ entity: Article) {
        entity.title = articleTitle
        entity.articleDescription = articleDescription
        entity.sourceName = articleSource
        entity.publishedAt = publishedAt
        entity.sourceUrl = sourceUrlString
        entity.author = articleAuthor
        entity.urlToImage = urlToImageString
    }

    
    init(article: ArticleModel) {
        self.article = article
    }
    
    init(favouriteArtivle: Article) {
        self.article = ArticleModel(favouriteArticle: favouriteArtivle)
    }
    
}
