//
//  ProfileViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //Profile Photo
    
    //User's Full Name
    
    //Email address
    
    //Lists of posts
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    let currentEmail: String
    
    init(currentEmail: String) {
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpSignOutButton()
        setUpTable()
        title = currentEmail
        navigationController?.tabBarItem.title = "Profile"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func setUpTable() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        setUpTableHeader()
        fetchProfileData()
    }
    
    private func setUpTableHeader(profilePictureURL: URL? = nil, name: String? = nil) {
        //Header View
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width))
        headerView.backgroundColor = UIColor(red: 228/255.0, green: 228/255.0, blue: 249/255.0, alpha: 1)
        tableView.tableHeaderView = headerView
        headerView.clipsToBounds = true
        
        //Profile Picture
        let profilePicture = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePicture.tintColor = .lightGray
        profilePicture.contentMode = .scaleAspectFit
        headerView.addSubview(profilePicture)
        profilePicture.frame = CGRect(x: (view.width-(view.width/4))/2,
                                      y: (headerView.height-(view.width/4))/1.8,
                                      width: view.width/4,
                                      height: view.width/4)
        
        //Email
        let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePicture.bottom + 20, width: view.width - 40, height: 100))
        headerView.addSubview(emailLabel)
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 25, weight: .medium)
        
        if let name = name {
            title = name
        }
        if let url = profilePictureURL {
            //Fetch image
        }
    }
    
    private func fetchProfileData() {
        
    }
    
    private func setUpSignOutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Sign Out",
            style: .done,
            target: self,
            action: #selector(didTapSignOut))
        navigationItem.rightBarButtonItem?.tintColor = Colors().darkViolet
    }
    
    @objc func didTapSignOut() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you would like to sign out?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] success in
                if success {
                    DispatchQueue.main.async {
                        UserDefaults.standard.set(nil, forKey: "name")
                        UserDefaults.standard.set(nil, forKey: "email")
                        
                        let signInVC = SignInViewController()
                        signInVC.navigationItem.largeTitleDisplayMode = .always
                        
                        let navVC = UINavigationController(rootViewController: signInVC)
                        navVC.navigationBar.prefersLargeTitles = true
                        navVC.modalPresentationStyle = .fullScreen
                        self?.present(navVC, animated: true, completion: nil)
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
}

        //MARK: Table View Methods

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Blog posts!"
        return cell
    }
    
    
}
