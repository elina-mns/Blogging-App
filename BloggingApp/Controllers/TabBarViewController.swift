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
        setUpControllers()
    }
    
    private func setUpControllers() {
        let home = HomeViewController()
        home.title = "Home"
        let profile = ProfileViewController()
        profile.title = "Profile"
        home.navigationItem.largeTitleDisplayMode = .always
        profile.navigationItem.largeTitleDisplayMode = .always
        
        let navigationControllerForHome = UINavigationController(rootViewController: home)
        let navigationControllerForProfile = UINavigationController(rootViewController: profile)
        navigationControllerForProfile.navigationBar.prefersLargeTitles = true
        navigationControllerForHome.navigationBar.prefersLargeTitles = true
        
        setViewControllers([navigationControllerForHome, navigationControllerForProfile], animated: true)
    }
}
