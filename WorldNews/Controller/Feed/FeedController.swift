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
    private var filteredArticles = [ArticleModel]()
    private let pageSize = 10
    private var page = 1
    private var readyToFetchNewPage = true
    
    private let customRefreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
       return refreshControl
    }()
    
    private let searchConttroller = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchConttroller.isActive && !(searchConttroller.searchBar.text?.isEmpty ?? true)
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain,
                                                            target: self, action: #selector(openSettings))
        
        navigationItem.title = "Feed"
        configureSearchController()
        configureTableView()
        fetchArticles()
    }
    
    // MARK: API
    
    func fetchArticles() {
        let (category, language, country, source) = fetchCategoriesForApiCall()
        
        AlamofireNetworkRequest.sendRequest(url: Constants.getUrlWith(apiKey: API_KEY,
                                                                      category: category,
                                                                      language: language,
                                                                      country: country,
                                                                      source: source,
                                                                      pageSize: pageSize), page: page) {[weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alert, animated: true)
            case .success(let articels):
                
                if self.inSearchMode == false {
                    if self.articles.count == self.pageSize * (self.page - 1) {
                        self.articles += articels
                    } else {
                        self.articles = articels
                    }
                    self.page += 1
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func fetchCategoriesForApiCall() -> (String?,String?,String?,String?) {
        var category: String? = SettingCategoriesModel.categoryItems[UserDefaults.standard.integer(forKey:"categoryRow")]
        var language: String? = SettingCategoriesModel.languageItems[UserDefaults.standard.integer(forKey:"languageRow")]
        var country: String? = SettingCategoriesModel.countryItems[UserDefaults.standard.integer(forKey:"countryRow")]
        var source: String? = SettingCategoriesModel.sourceItems[UserDefaults.standard.integer(forKey:"sourceRow")]

        if source != "No selection",
            country != "No selection" ||
            category != "No selection" {
            let alert = UIAlertController(title: "Error", message: "You cannot mix the sources parameter with the country or category parameters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        if category == "No selection" { category = nil }
        if language == "No selection" { language = nil }
        if country == "No selection" { country = nil }
        if source == "No selection" { source = nil }
        
        return (category,language,country,source)
    }
    
    // MARK: Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        tableView.register(UINib(nibName: "ArticleCell", bundle: nil), forCellReuseIdentifier: ArticleCell.reuseId)
        tableView.refreshControl = customRefreshControl
    }
    
    func configureSearchController() {
        searchConttroller.searchResultsUpdater = self
        searchConttroller.obscuresBackgroundDuringPresentation = false
        searchConttroller.hidesNavigationBarDuringPresentation = false
        searchConttroller.searchBar.placeholder = "Search"
        navigationItem.searchController = searchConttroller
        definesPresentationContext = false
    }
    
    // MARK: Objc funcs
    
    @objc private func refresh(sender: UIRefreshControl) {
        page = 1
        fetchArticles()
        sender.endRefreshing()
    }
    
    @objc private func openSettings() {
        let vc = SettingsController()
        vc.delegate = self
        self.present(vc, animated: true)
    }
}


// MARK: UITableViewDataSource

extension FeedController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredArticles.count : articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseId, for: indexPath) as! ArticleCell
        
        let article = inSearchMode ? filteredArticles[indexPath.row] : articles[indexPath.row]
        cell.viewModel = ArticleCellViewModel(article: article)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if inSearchMode { return }
        let lastItemIndex = articles.count - 1
        if indexPath.row == lastItemIndex &&
           articles.count >= pageSize &&
            ArticleModel.totalResults > articles.count {
            if readyToFetchNewPage {
                readyToFetchNewPage = false
                Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                    timer.invalidate()
                    print("!!! fetchArticles")
                    self.fetchArticles()
                    self.readyToFetchNewPage = true
                }
            }
        }
    }
    
}

// MARK: UISearchResultsUpdating

extension FeedController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
        filteredArticles = articles.filter {
            $0.title?.lowercased().contains(searchText) ?? false || $0.description?.lowercased().contains(searchText) ?? false
        }
        self.tableView.reloadData()
    }
    
    
}

// MARK: ArticleCellDelegate

extension FeedController: ArticleCellDelegate {
    func didTapImage(with url: String) {
        let vc = WKWebViewController(urlString: url)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

// MARK: SettingsControllerDelegate

extension FeedController: SettingsControllerDelegate {
    func didFinishSettingSettings() {
        page = 1
        fetchArticles()
    }
    
    
}
