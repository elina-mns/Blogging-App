//
//  TabBarViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpControllers()
    }
    
    private func setUpControllers() {
        guard let currentUserEmail = UserDefaults.standard.string(forKey: "email") else { return }
        
        let home = HomeViewController()
        home.title = "Home"
        let profile = ProfileViewController(currentEmail: currentUserEmail)
        profile.title = "Profile"
        
        home.navigationItem.largeTitleDisplayMode = .always
        profile.navigationItem.largeTitleDisplayMode = .always
        
        let navigationControllerForHome = UINavigationController(rootViewController: home)
        let navigationControllerForProfile = UINavigationController(rootViewController: profile)
        navigationControllerForProfile.navigationBar.prefersLargeTitles = true
        navigationControllerForHome.navigationBar.prefersLargeTitles = true
        
        navigationControllerForHome.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        navigationControllerForProfile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        
        setViewControllers([navigationControllerForHome, navigationControllerForProfile], animated: true)
    }
}
