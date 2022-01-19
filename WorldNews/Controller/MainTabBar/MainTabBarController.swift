//
//  MainTabBarController.swift
//  WorldNews
//
//  Created by Alex Mosunov on 19.01.2022.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        configureViewControllers()
    }
    
    
    func configureViewControllers() {
        
        let feedVC = FeedController()
        feedVC.tabBarItem = UITabBarItem(title: "Feed",
                                         image: UIImage(systemName: "list.bullet.circle"),
                                         selectedImage: UIImage(systemName: "list.bullet.circle.fill"))
        
        let favouritesVC = FavouritesController()
        favouritesVC.tabBarItem = UITabBarItem(title: "Favourites",
                                               image: UIImage(systemName: "star.circle"),
                                               selectedImage: UIImage(systemName: "star.circle.fill"))
        
        viewControllers = [feedVC, favouritesVC]
        
        tabBar.tintColor = .systemIndigo
        tabBar.backgroundColor = .white
    }
}
