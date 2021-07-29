//
//  SignInViewController.swift
//  BloggingApp
//
//  Created by Elina Mansurova on 2021-07-23.
//

import UIKit

class SignInViewController: UITabBarController {
    
    //MARK: Properties
    
    //Header View
    private let headerView = SignInHeaderView()
    
    //Email Field
    private let emailField: UITextField = {
       let field = UITextField()
        field.keyboardType = .emailAddress
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "Email"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    //Password Field
    private let passwordField: UITextField = {
       let field = UITextField()
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        field.placeholder = "Password"
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.isSecureTextEntry = true
        field.leftViewMode = .always
        field.backgroundColor = .secondarySystemBackground
        field.layer.cornerRadius = 8
        field.layer.masksToBounds = true
        return field
    }()
    
    //Sign In Button
    private let signInButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = UIColor(red: 39/255.0, green: 39/255.0, blue: 39/255.0, alpha: 1)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        return button
    }()
    
    //Create Account
    private let createAccountButton: UIButton = {
       let button = UIButton()
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 8
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(headerView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
        title = "Sign In"
        view.backgroundColor = .systemBackground
        
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height / 4)
        emailField.frame = CGRect(x: 20, y: headerView.bottom, width: view.width - 40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 20, width: view.width - 40, height: 50)
        signInButton.frame = CGRect(x: 20, y: passwordField.bottom + 20, width: view.width - 40, height: 50)
        createAccountButton.frame = CGRect(x: 20, y: signInButton.bottom + 10, width: view.width - 40, height: 50)
        
    }
    
    //MARK: Actions
    
    @objc func didTapSignIn() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty else { return }
        AuthManager.shared.signIn(email: email, password: password) { [weak self] success in
            if success {
                DispatchQueue.main.async {
                    UserDefaults.standard.set(email, forKey: "email")
                    let vc = TabBarViewController()
                    vc.modalPresentationStyle = .fullScreen
                    self?.present(vc, animated: true)
                }
            }
        }
    }
    
    @objc func didTapCreateAccount() {
        let vc = SignUpViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
