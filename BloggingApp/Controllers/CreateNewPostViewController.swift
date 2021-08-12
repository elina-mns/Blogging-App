//
//  CreateNewPostViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

class CreateNewPostViewController: UITabBarController {
    
    //MARK: Properties
    
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
        headerImageView.contentMode = .scaleToFill
        headerImageView.isUserInteractionEnabled = true
        headerImageView.image = UIImage(systemName: "photo")
        headerImageView.tintColor = .darkGray
        headerImageView.backgroundColor = Colors().lightGreen
        headerImageView.layer.cornerRadius = 8
        return headerImageView
    }()
    
    private var selectedHeaderImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        return imageView
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
        configureTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleField.frame = CGRect(x: 10, y: view.safeAreaInsets.top + 20, width: view.width - 20, height: 50)
        headerImageView.frame = CGRect(x: 30, y: titleField.bottom + 30, width: view.width - 60, height: 200)
        contentTextView.frame = CGRect(x: 20, y: headerImageView.bottom + 20, width: view.width - 40, height: 400)
    }
    
    func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post!", style: .done, target: self, action: #selector(didTapPost))
    }
    
    func configureTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapHeaderImage))
        headerImageView.addGestureRecognizer(tap)
    }
    
    //MARK: Objc methods
    
    @objc func didTapCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapHeaderImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    @objc func didTapPost() {
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let title = titleField.text,
              let body = contentTextView.text,
              let image = selectedHeaderImage.image,
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            let alertMessage = UIAlertController(title: "Enter post details", message: "Please enter a title, body and pick an image to continue", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alertMessage, animated: true)
            return
        }
        
        let postId = UUID().uuidString
        //Upload header image
        StorageManager.shared.uploadHeaderImage(email: email, postId: postId, image: image) { success in
            guard success else {
                print("Failed to upload URL for header")
                return
            }
            
            //Get url
            StorageManager.shared.downloadURLForPostHeader(email: email, postId: postId) { url in
                guard let headerURL = url else { return }
                
                //Insert post into DB
                let post = BlogPost(id: postId, title: title, timestamp: Date().timeIntervalSince1970, headerImageURL: headerURL, text: body)
                
                DatabaseManager.shared.addBlogPost(withPost: post, email: email) { [weak self] posted in
                    guard posted else {
                        print("Failed to post new article")
                        return
                    }
                    DispatchQueue.main.async {
                        self?.didTapCancel()
                    }
                }
            }
        }
    }
}

    //MARK: Image Picker Controller methods

extension CreateNewPostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let image = info[.originalImage] as? UIImage else { return }
        selectedHeaderImage.image = image
        headerImageView.image = image
    }
}
