//
//  ArticleCell.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import UIKit

class ArticleCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseId = "ArticleCell"
    
    var viewModel: ArticleCellViewModel? {
        didSet { configure() }
    }
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .green
    }

    // MARK: Helpers
    
    private func configure() {
        print("DEBIG - configure")
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.articleTitle
        descriptionLabel.text = viewModel.articleDescription
        authorLabel.text = viewModel.articleAuthor
        sourceLabel.text = viewModel.articleSource
    }
}
