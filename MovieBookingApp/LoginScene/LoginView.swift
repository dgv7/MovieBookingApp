//
//  Login.swift
//  MovieBookingApp
//
//  Created by t2023-m0119 on 7/22/24.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let signupViewController = SignupViewController()

    private let emailTextField = UITextField()
    private let passwordTextField = UITextField()
    private let loginButton = UIButton()
    private let signupButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "Login"
        
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
        
        loginButton.setTitle("Login", for: .normal)
        loginButton.backgroundColor = .blue
        loginButton.layer.cornerRadius = 10
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.backgroundColor = .gray
        signupButton.layer.cornerRadius = 10
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        
        NSLayoutConstraint.activate([
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            passwordTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            signupButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc private func loginButtonTapped() {
        
        // 입력값 여부 확인
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            return
        }
        // 데이터 저장 후 뷰 전환
        if let savedPassword = UserDefaultsManager.shared.getPassword(for: email), savedPassword == password {
            
//            UserDefaultsManager.shared.saveCredentials(email: email, password: password, nickname: "nickname")
            
//            let myPageVC = MyPageViewController()
//            myPageVC.email = email

            let nextPage = MovieViewController()
            navigationController?.pushViewController(nextPage, animated: true)
        } else {
            // handle incorrect credentials
            print("Invalid email or password.")
        }
    }
    
    @objc private func signupButtonTapped() {
        let signupVC = SignupViewController()
        signupVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(signupVC, animated: true)
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
    // 한국어 입력 금지
    private func containsKorean(text: String) -> Bool {
        for scalar in text.unicodeScalars {
            if (scalar.value >= 0xAC00 && scalar.value <= 0xD7AF) {
                return true
            }
        }
        return false
    }
}
