//
//  ArticleCell.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import UIKit
import SDWebImage

protocol ArticleCellDelegate: AnyObject {
    func didTapImage(with url: String)
}

class ArticleCell: UITableViewCell {
    
    // MARK: Properties
    static let reuseId = "ArticleCell"
    
    var viewModel: ArticleCellViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: ArticleCellDelegate?
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var newsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    

    // MARK: Helpers
    
    private func configure() {
        guard let viewModel = viewModel else { return }
        titleLabel.text = viewModel.articleTitle
        descriptionLabel.text = viewModel.articleDescription
        authorLabel.text = viewModel.articleAuthor
        sourceLabel.text = viewModel.articleSource
        newsImageView.sd_setImage(with: viewModel.urlToImage)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        newsImageView.addGestureRecognizer(tap)
        newsImageView.isUserInteractionEnabled = true
    }
    
    
    // MARK: Objc funcs
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let urlString = viewModel?.sourceUrlString else { return }
        delegate?.didTapImage(with: urlString)
    }
    
}
