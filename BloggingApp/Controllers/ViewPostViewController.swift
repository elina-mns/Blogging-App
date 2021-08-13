//
//  ViewPostViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

class ViewPostViewController: UITabBarController {
    
    private var post: BlogPost
    
    //Initializers
    init(withPost post: BlogPost) {
        self.post = post
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
        //title, header, body
        let tableView = UITableView()
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.register(PostHeaderTableViewCell.self,
                           forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        tableView.separatorStyle = .none
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
}

   //MARK: Table View Methods

extension ViewPostViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3 //title, image and text
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = post.title
            cell.textLabel?.font = .systemFont(ofSize: 20, weight: .medium)
            cell.selectionStyle = .none
            return cell
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier, for: indexPath) as? PostHeaderTableViewCell {
                cell.selectionStyle = .none
                cell.configure(withViewModel: .init(imageURL: post.headerImageURL))
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = post.text
            cell.textLabel?.font = .systemFont(ofSize: 18, weight: .medium)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.lineBreakMode = .byWordWrapping
            cell.selectionStyle = .none
        default:
            break
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        switch index {
        case 0:
            return 50
        case 1:
            return 150
        case 2:
            return 200
        default:
            break
        }
        return UITableView.automaticDimension
    }
}
