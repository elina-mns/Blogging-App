//
//  CreateNewPostViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

class CreateNewPostViewController: UITabBarController {
    
    //Title field
    
    private let titleField: UITextField = {
       let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "Enter title..."
        field.autocapitalizationType = .words
        field.autocorrectionType = .yes
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    //Image Header
    
    private var headerImageView: UIImageView = {
        let headerImageView = UIImageView()
        headerImageView.contentMode = .center
        headerImageView.isUserInteractionEnabled = true
        headerImageView.image = UIImage(systemName: "photo")
        headerImageView.tintColor = .darkGray
        headerImageView.backgroundColor = Colors().lightGreen
        headerImageView.layer.cornerRadius = 8
        return headerImageView
    }()
    
    //TextView for the post
    
    private var contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.layer.shadowRadius = 8
        textView.text = "Enter your post here..."
        textView.textColor = UIColor.lightGray
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleField)
        view.addSubview(headerImageView)
        view.addSubview(contentTextView)
        configureButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 20, width: view.width - 20, height: 50)
        headerImageView.frame = CGRect(x: 30, y: titleField.bottom + 20, width: view.width - 70, height: 200)
        contentTextView.frame = CGRect(x: 20, y: headerImageView.bottom + 20, width: view.width - 40, height: view.height - 210 - view.safeAreaInsets.top - 50)
    }
    
    func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post!", style: .done, target: self, action: #selector(didTapPost))
    }
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapPost() {
        
    }

}
