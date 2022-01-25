//
//  ArticleCell.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import UIKit
import SDWebImage
import CoreData

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
    private var isFavourite = false
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var sourceLabel: UILabel!
    @IBOutlet var addToFavouritesButton: UIButton!
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
        
        addToFavouritesButton.setImage(UIImage(systemName: "star"), for: .normal)
        addToFavouritesButton.setTitle("", for: .normal)
        addToFavouritesButton.tintColor = .systemYellow
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        newsImageView.addGestureRecognizer(tap)
        newsImageView.isUserInteractionEnabled = true
    }
    
    
    // MARK: Actions
    
    @IBAction func addToFavouritesButtonDidTap(_ sender: UIButton) {
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            guard let viewModel = viewModel else { return }
            viewModel.initializeCoreDataEntity(Article(context: context))
            
            CoreDataManager.shared.saveContext()
        }
       
        
        isFavourite.toggle()
        if isFavourite {
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        guard let urlString = viewModel?.sourceUrlString else { return }
        delegate?.didTapImage(with: urlString)
    }
    
}
