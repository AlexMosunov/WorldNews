//
//  FavouritesController.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import UIKit
import CoreData

class FavouritesController: UITableViewController {
    
    // MARK: Properties
    
    private var articles = [Article]()
    
    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        loadItems()
    }
    
    // MARK: Helpers
    
    private func configureTableView() {
        view.backgroundColor = .white
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: ArticleCell.reuseId)
    }
    
    private func loadItems() {
        DispatchQueue.main.async {
            self.articles = CoreDataManager.shared.loadArticles()
            self.tableView.reloadData()
        }
    }

}

// MARK: UITableViewDataSource

extension FavouritesController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as! ArticleCell
        
        let article = articles[indexPath.row]
        cell.viewModel = ArticleCellViewModel(favouriteArtivle: article)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    
}


// MARK: ArticleCellDelegate

extension FavouritesController: ArticleCellDelegate {
    func didTapImage(with url: String) {
        let vc = WKWebViewController(urlString: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
