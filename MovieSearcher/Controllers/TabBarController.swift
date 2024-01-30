//
//  ViewController.swift
//  MovieSearcher
//
//  Created by MacBook on 29.01.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarItems()
        tabBar.tintColor = .label
    }
    
    private func configureTabBarItems() {
        guard let listVC = UIStoryboard(name: "MovieList", bundle: nil).instantiateViewController(withIdentifier: "ListVCIdentifier") as? ListVC
        else { return }
        let favoritesVC = FavoritesVC()
        
        listVC.tabBarItem = UITabBarItem(title: "Movies List", image: UIImage(systemName: "list.bullet.clipboard"), tag: 0)
        favoritesVC.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "star.circle.fill"), tag: 1)
        
        let listNavigationVC = UINavigationController(rootViewController: listVC)
        let favoritesNavigationVC = UINavigationController(rootViewController: favoritesVC)
        setViewControllers([listNavigationVC, favoritesNavigationVC], animated: true)
    }
}

