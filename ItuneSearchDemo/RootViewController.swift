//
//  RootViewController.swift
//  ItuneSearchDemo
//
//  Created by Patrick Tang on 20/10/2023.
//

import UIKit

final class RootViewController: UITabBarController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        view.backgroundColor = .white
        // Initial and injecting viewModel needed
        let searchListViewController = SearchListViewController(viewModel: SearchListViewModel(trackService: TrackService()))
        searchListViewController.title = "Search"
        searchListViewController.tabBarItem = UITabBarItem(title: "Search", image: UIImage(named: "search_icon"), tag: 0)
        
        let favouriteListViewController = FavouriteListViewController()
        favouriteListViewController.title = "Favourite"
        favouriteListViewController.tabBarItem = UITabBarItem(title: "Favourite", image: UIImage(named: "favourite_icon"), tag: 1)
        
        let controllers = [searchListViewController, favouriteListViewController]
        
        // Wrap the controllers into navigationController
        self.viewControllers = controllers.map {
            let navigationController: UINavigationController = UINavigationController(rootViewController: $0)
            navigationController.navigationBar.prefersLargeTitles = true
            return navigationController
        }
    }
}

extension RootViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {}
}
