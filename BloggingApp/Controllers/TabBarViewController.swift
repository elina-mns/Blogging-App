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
        navigationControllerForHome.tabBarItem.standardAppearance?.backgroundColor = Colors().darkViolet
        navigationControllerForProfile.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
        navigationControllerForProfile.tabBarItem.badgeColor = Colors().darkViolet
        
        setViewControllers([navigationControllerForHome, navigationControllerForProfile], animated: true)
    }
}

extension UITabBarController {
    
    func addBadge(index: Int, value: Int, color: UIColor, font: UIFont) {

        let itemPosition = CGFloat(index + 1)
        let itemWidth: CGFloat = tabBar.frame.width / CGFloat(tabBar.items!.count)

        let bgColor = color

        let xOffset: CGFloat = 5
        let yOffset: CGFloat = -12

        let badgeView = PGTabBadge()
        badgeView.frame.size =  CGSize(width: 12, height: 12)
        badgeView.center = CGPoint(x: (itemWidth * itemPosition) - (itemWidth / 2) + xOffset, y: 20 + yOffset)
        badgeView.layer.cornerRadius = badgeView.bounds.width/2
        badgeView.clipsToBounds = true
        badgeView.textColor = UIColor.white
        badgeView.textAlignment = .center
        badgeView.font = font
        badgeView.text = String(value)
        badgeView.backgroundColor = bgColor
        badgeView.tag = index
        tabBar.addSubview(badgeView)

    }
}

class PGTabBadge: UILabel { }
    
