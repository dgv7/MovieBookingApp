//
//  SingUp.swift
//  MovieBookingApp
//
//  Created by t2023-m0119 on 7/22/24.
//

import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {

    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let nicknameTextField = UITextField()
    private let signupButton = UIButton()
    private let errorMessageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "Sign Up"
        
        setupUI()
    }
    
    private func setupUI() {
        emailTextField.placeholder = "Email"
        emailTextField.borderStyle = .roundedRect
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocapitalizationType = .none
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.delegate = self
        
        passwordTextField.placeholder = "Password"
        passwordTextField.borderStyle = .roundedRect
        passwordTextField.isSecureTextEntry = true
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        nicknameTextField.placeholder = "Nickname"
        nicknameTextField.borderStyle = .roundedRect
        nicknameTextField.autocapitalizationType = .none
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.backgroundColor = .blue
        signupButton.layer.cornerRadius = 10
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        errorMessageLabel.textColor = .red
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(nicknameTextField)
        view.addSubview(signupButton)
        view.addSubview(errorMessageLabel)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            nicknameTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            signupButton.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 20),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            errorMessageLabel.topAnchor.constraint(equalTo: signupButton.bottomAnchor, constant: 20),
            errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func signupButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
                let nickname = nicknameTextField.text, !nickname.isEmpty else {
            errorMessageLabel.text = "Email and Password are required."
            return
        }
        
        if containsKorean(text: email) {
            errorMessageLabel.text = "Email cannot contain Korean characters."
            return
        }
        
        // 회원가입 로직
        UserDefaultsManager.shared.saveCredentials(email: email, password: password, nickname: nickname)
        navigationController?.popViewController(animated: true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == emailTextField {
            return isValidEmailCharacter(string)
        }
        return true
    }
    
    private func isValidEmailCharacter(_ string: String) -> Bool {
        if string.rangeOfCharacter(from: CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@._-").inverted) != nil {
            return false
        }
        return !containsKorean(text: string)
    }
    
    private func containsKorean(text: String) -> Bool {
        for scalar in text.unicodeScalars {
            if (scalar.value >= 0xAC00 && scalar.value <= 0xD7AF) {
                return true
            }
        }
        return false
    }
}
