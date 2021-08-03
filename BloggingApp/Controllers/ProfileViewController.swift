//
//  ProfileViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

class ProfileViewController: UIViewController {
    
    //MARK: Properties
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    private var user: User?
    let currentEmail: String
    
    //MARK: Initializers
    
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
    
    private func setUpTableHeader(profilePictureRef: String? = nil, name: String? = nil) {
        //Header View
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width))
        headerView.backgroundColor = UIColor(red: 228/255.0, green: 228/255.0, blue: 249/255.0, alpha: 1)
        tableView.tableHeaderView = headerView
        headerView.isUserInteractionEnabled = true
        headerView.clipsToBounds = true
        
        //Profile Picture
        let profilePicture = UIImageView(image: UIImage(systemName: "person.circle"))
        profilePicture.tintColor = .lightGray
        profilePicture.contentMode = .scaleAspectFit
        profilePicture.isUserInteractionEnabled = true
        headerView.addSubview(profilePicture)
        profilePicture.frame = CGRect(x: (view.width-(view.width/4))/2,
                                      y: (headerView.height-(view.width/4))/1.8,
                                      width: view.width/4,
                                      height: view.width/4)
        
        //Tap on Profile Picture to set a Picture
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePicture))
        profilePicture.addGestureRecognizer(tap)
        
        //Email
        let emailLabel = UILabel(frame: CGRect(x: 20, y: profilePicture.bottom + 20, width: view.width - 40, height: 100))
        headerView.addSubview(emailLabel)
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 25, weight: .medium)
        
        if let name = name {
            title = name
        }
        if let url = profilePictureRef {
            //Fetch image
        }
    }
    
    @objc func didTapProfilePicture() {
        //"Guard" so user can't change other users' profile pictures
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              myEmail != currentEmail else { return }
        
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    private func fetchProfileData() {
        DatabaseManager.shared.getUser(email: currentEmail) { [weak self] user in
            guard let user = user else { return }
            self?.user = user
            DispatchQueue.main.async {
                self?.setUpTableHeader(profilePictureRef: user.profilePictureReference, name: user.name)
            }
        }
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
 
        //MARK: Image Picker Methods

extension ProfileViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.editedImage] as? UIImage else { return }
        
        StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image) { success in
            
        }
    }
}
