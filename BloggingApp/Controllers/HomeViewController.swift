//
//  ViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var posts: [BlogPost] = []
    
    //Floating Button:
    private let composeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors().darkViolet
        button.setImage(UIImage(systemName: "square.and.pencil",
                                withConfiguration: UIImage.SymbolConfiguration(pointSize: 30, weight: .medium)), for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 40
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        button.isUserInteractionEnabled = true
        return button
    }()
    
    //TableView:
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self, forCellReuseIdentifier: PostPreviewTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(didTapCompose), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        fetchAllPosts()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        composeButton.frame = CGRect(x: view.frame.width - 96,
                                     y: view.frame.height - 96 - view.safeAreaInsets.bottom,
                                     width: 80, height: 80)
        tableView.frame = view.bounds
    }
    
    @objc func didTapCompose() {
        let vc = CreateNewPostViewController()
        vc.title = "Create Post"
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func fetchAllPosts() {
        DatabaseManager.shared.getAllPosts { [weak self] posts in
            self?.posts = posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = posts[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifier, for: indexPath) as? PostPreviewTableViewCell {
            
            cell.configure(withViewModel: .init(title: post.title, imageURL: post.headerImageURL))
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ViewPostViewController(withPost: posts[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
}
