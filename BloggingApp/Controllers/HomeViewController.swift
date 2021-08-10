//
//  ViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

class HomeViewController: UIViewController {
    
    //Floating Button:
    
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors().darkViolet
        button.setImage(UIImage(systemName: "square.and.pencil",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 34, weight: .medium)), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 40
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        button.isUserInteractionEnabled = true
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(didTapCompose), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composeButton.frame = CGRect(x: view.frame.width - 18 - 80,
                                     y: view.frame.height - 18 - 80 - view.safeAreaInsets.bottom,
                                     width: 80, height: 80)
    }
    
    @objc func didTapCompose() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }


}

