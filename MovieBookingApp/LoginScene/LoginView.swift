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

    private let stackView = UIStackView()

        override func viewDidLoad() {
            super.viewDidLoad()
            
            view.backgroundColor = .white
            self.title = "Login"
            
//            let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
//                self.navigationItem.backBarButtonItem = backBarButtonItem
            setupUI()
        }
        
        private func setupUI() {
            emailTextField.placeholder = "Email을 입력하세요"
            emailTextField.borderStyle = .roundedRect
            emailTextField.keyboardType = .emailAddress
            emailTextField.autocapitalizationType = .none // 자동 대문자 비활성화
            emailTextField.autocorrectionType = .no // 자동 수정 비활성화
            emailTextField.spellCheckingType = .no  // 맞춤범 검사 비활성화
            emailTextField.returnKeyType = .next    // return -> next(다음) 변경
            emailTextField.clearButtonMode = .always    // 입력내용 삭제 버튼
            emailTextField.becomeFirstResponder()   // 화면에서 첫번째 반응
            emailTextField.translatesAutoresizingMaskIntoConstraints = false
            emailTextField.delegate = self
            
            passwordTextField.placeholder = "Password를 입력하세요"
            passwordTextField.borderStyle = .roundedRect
            passwordTextField.isSecureTextEntry = true // 보안 입력 활성화
            passwordTextField.textContentType = .oneTimeCode // 자동 완성 및 강력한 비밀번호 제안 비활성화
            passwordTextField.autocapitalizationType = .none // 자동 대문자 비활성화
            passwordTextField.autocorrectionType = .no // 자동 수정 비활성화
            passwordTextField.spellCheckingType = .no  // 맞춤범 검사 비활성화
            passwordTextField.returnKeyType = .done    // return -> done(완료) 변경
            passwordTextField.clearButtonMode = .always    // 입력내용 삭제 버튼
            passwordTextField.translatesAutoresizingMaskIntoConstraints = false
            
            loginButton.setTitle("Login", for: .normal)
            loginButton.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
            loginButton.layer.cornerRadius = 10
            loginButton.translatesAutoresizingMaskIntoConstraints = false
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
            
            signupButton.setTitle("Sign Up", for: .normal)
            signupButton.backgroundColor = .gray
            signupButton.layer.cornerRadius = 10
            signupButton.translatesAutoresizingMaskIntoConstraints = false
            signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
            
            stackView.axis = .vertical
            stackView.spacing = 20
            stackView.alignment = .fill
            stackView.distribution = .equalSpacing
            stackView.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(emailTextField)
            stackView.addArrangedSubview(passwordTextField)
            stackView.addArrangedSubview(loginButton)
            stackView.addArrangedSubview(signupButton)
            
            view.addSubview(stackView)
            
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
            ])
        }
    // 로그아웃시 입력된 값 초기화
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            emailTextField.text = ""
            passwordTextField.text = ""
        }
    
    @objc private func loginButtonTapped() {
        // 입력값 여부 확인
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error", message: "Email과 Password를 모두 입력해주세요.")
            return
        }
        // 데이터 저장 후 뷰 전환
        if let savedPassword = UserDefaultsManager.shared.getPassword(for: email), savedPassword == password {
            let nextPage = MovieViewController()
            navigationController?.pushViewController(nextPage, animated: true)
        } else {
            // 이메일이 없거나 비밀번호가 틀린 경우
            showAlert(title: "Error", message: "없는 계정입니다. 회원가입을 해주세요.")
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func signupButtonTapped() {
        let signupVC = SignupViewController()
        signupVC.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(signupVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            if emailTextField.text != "" {
                // 이메일 입력시 패스워드로 자동 이동
                passwordTextField.becomeFirstResponder()
            }
        case passwordTextField:
            if passwordTextField.text != "" {
                // 닉네임 입력시 키보드 내림
                passwordTextField.resignFirstResponder()
            }
        default:
            break
        }
        return true
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
