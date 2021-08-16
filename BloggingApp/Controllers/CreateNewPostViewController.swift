//
//  CreateNewPostViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

protocol CreateNewPostViewControllerDelegate: AnyObject {
    func updateTableView()
}

class CreateNewPostViewController: UITabBarController {
    
    //MARK: Properties
    private var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    weak var tableViewDelegate: CreateNewPostViewControllerDelegate?
    
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
    
    //Tap to pick an image Label
    private var label: UILabel = {
        let label = UILabel()
        label.text = "Tap to pick an image here!"
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textColor = .darkGray
        label.contentMode = .center
        return label
    }()
    
    //Image Header
    private var headerImageView: UIImageView = {
        let headerImageView = UIImageView()
        headerImageView.contentMode = .scaleToFill
        headerImageView.isUserInteractionEnabled = true
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
        textView.text = "Enter your post here..."
        textView.layer.cornerRadius = 8
        textView.layer.shadowRadius = 8
        textView.textColor = UIColor.lightGray
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(titleField)
        view.addSubview(headerImageView)
        view.addSubview(contentTextView)
        view.addSubview(activityIndicator)
        activityIndicator.isHidden = true
        headerImageView.addSubview(label)
        contentTextView.delegate = self
        configureButtons()
        configureTapGesture()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        titleField.frame = CGRect(x: 30, y: view.safeAreaInsets.top + 30, width: view.width - 60, height: 50)
        headerImageView.frame = CGRect(x: 30, y: titleField.bottom + 30, width: view.width - 60, height: 200)
        contentTextView.frame = CGRect(x: 30, y: headerImageView.bottom + 20, width: view.width - 60, height: 400)
        label.frame = CGRect(x: 45, y: headerImageView.safeAreaInsets.top + 50, width: headerImageView.width, height: headerImageView.height/2)
        activityIndicator.frame = CGRect(x: view.center.x, y: view.center.y, width: 15, height: 15)
    }
    
    func configureButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapCancel))
        navigationItem.leftBarButtonItem?.tintColor = .darkGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post!", style: .done, target: self, action: #selector(didTapPost))
        navigationItem.rightBarButtonItem?.tintColor = .darkGray
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
        activityIndicator.startAnimating()
        guard let email = UserDefaults.standard.string(forKey: "email"),
              let title = titleField.text,
              let body = contentTextView.text,
              let image = selectedHeaderImage.image,
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            let alertMessage = UIAlertController(title: "Enter post details", message: "Please enter a title, body and pick an image to continue", preferredStyle: .alert)
            alertMessage.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alertMessage, animated: true)
            activityIndicator.stopAnimating()
            self.tableViewDelegate?.updateTableView()
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
                        self?.activityIndicator.stopAnimating()
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
        activityIndicator.stopAnimating()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        activityIndicator.startAnimating()
        label.isHidden = true
        guard let image = info[.originalImage] as? UIImage else { return }
        selectedHeaderImage.image = image
        headerImageView.image = image
        activityIndicator.stopAnimating()
    }
}

     //MARK: Textview Methods for Placeholder

extension CreateNewPostViewController: UITextViewDelegate  {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter your post here..."
            textView.textColor = UIColor.lightGray
        }
    }
}
