//
//  FeedController.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import UIKit

class FeedController: UITableViewController {
    
    // MARK: Properties
    
    private var articles = [ArticleModel]()
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchUsers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureTableView()
        fetchUsers()
    }
    
    
    // MARK: API
    
    func fetchUsers() {
        AlamofireNetworkRequest.sendRequest(url: Constants.getUrlWith(apiKey: API_KEY,
                                                                      category: "business",
                                                                      language: "en")) {[weak self](result) in
            switch result {
            case .failure(let error):
                //                AlertController.showError(message: error.localizedDescription, on: self)
                print("ERROR _ \(error)")
            case .success(let articels):
                guard let self = self else { return }
                self.articles = articels
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                print("article 2 - \(self.articles[2])!")
            }
        }
    }
    
    // MARK: Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: ArticleCell.reuseId)
    }
    
}


// MARK: UITableViewDataSource

extension FeedController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as! ArticleCell
        
        let article = articles[indexPath.row]
        cell.viewModel = ArticleCellViewModel(article: article)
        
        if indexPath.row == 2 {
            return UITableViewCell()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
