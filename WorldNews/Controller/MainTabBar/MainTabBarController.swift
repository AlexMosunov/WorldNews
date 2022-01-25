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
        configureViewControllers()
    }
    
    
    func configureViewControllers() {
        
        let feedVC = templateNavigationController(unselectedImage: UIImage(systemName: "list.bullet.circle"),
                                                  selectedImage: UIImage(systemName: "list.bullet.circle.fill"),
                                                  title: "Feed",
                                                  rootViewController: FeedController())
        
        let favouritesVC = FavouritesController()
        favouritesVC.tabBarItem = UITabBarItem(title: "Favourites",
                                               image: UIImage(systemName: "star.circle"),
                                               selectedImage: UIImage(systemName: "star.circle.fill"))
        
        viewControllers = [feedVC, favouritesVC]
        
        tabBar.tintColor = .systemIndigo
        tabBar.backgroundColor = .white
    }
    
    func templateNavigationController(unselectedImage: UIImage?, selectedImage: UIImage?, title: String?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = unselectedImage
        nav.tabBarItem.selectedImage = selectedImage
        nav.tabBarItem.title = title
        nav.navigationBar.tintColor = .black
        return nav
    }
    
}
