import UIKit

class SignupViewController: UIViewController, UITextFieldDelegate {
    
    let emailTextField = UITextField()
    let passwordTextField = UITextField()
    let nicknameTextField = UITextField()
    private let signupButton = UIButton()
    private let errorMessageLabel = UILabel()
    
    private let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.title = "Sign Up"
        
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
        passwordTextField.returnKeyType = .next    // return -> next(다음) 변경
        passwordTextField.clearButtonMode = .always    // 입력내용 삭제 버튼
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.delegate = self
        
        nicknameTextField.placeholder = "Nickname을 입력하세요"
        nicknameTextField.borderStyle = .roundedRect
        nicknameTextField.autocapitalizationType = .none // 자동 대문자 비활성화
        nicknameTextField.autocorrectionType = .no // 자동 수정 비활성화
        nicknameTextField.spellCheckingType = .no  // 맞춤범 검사 비활성화
        nicknameTextField.returnKeyType = .done    // return -> done(완료) 변경
        nicknameTextField.clearButtonMode = .always    // 입력내용 삭제 버튼
        nicknameTextField.translatesAutoresizingMaskIntoConstraints = false
        nicknameTextField.delegate = self
        
        signupButton.setTitle("Sign Up", for: .normal)
        signupButton.backgroundColor = #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        signupButton.layer.cornerRadius = 10
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.addTarget(self, action: #selector(signupButtonTapped), for: .touchUpInside)
        
        errorMessageLabel.textColor = .red
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(nicknameTextField)
        stackView.addArrangedSubview(signupButton)
        stackView.addArrangedSubview(errorMessageLabel)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        ])
    }
    
    @objc private func signupButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty,
              let nickname = nicknameTextField.text, !nickname.isEmpty else {
            errorMessageLabel.text = "올바른 Email, Password, Nickname을 모두 입력해주세요"
            return
        }
        // Generate UUID
        let userId = UUID()
        
        // 회원가입 로직
        UserDefaultsManager.shared.saveCredentials(email: email, password: password, nickname: nickname, userId: userId)
        // 로그인된 사용자 정보 저장
        UserDefaultsManager.shared.setCurrentUserEmail(email: email)
        navigationController?.popViewController(animated: true)
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
                // 패스워드 입력시 닉네임으로 자동 이동
                nicknameTextField.becomeFirstResponder()
            }
        case nicknameTextField:
            if nicknameTextField.text != "" {
                // 닉네임 입력시 키보드 내림
                nicknameTextField.resignFirstResponder()
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
    // 한글 입력 방지
    private func isValidEmailCharacter(_ string: String) -> Bool {
        let allowedCharacters = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@._-")
        return string.rangeOfCharacter(from: allowedCharacters.inverted) == nil && !containsKorean(string)
    }

    private func containsKorean(_ text: String) -> Bool {
        return text.rangeOfCharacter(from: CharacterSet(charactersIn: "\u{AC00}"..."\u{D7AF}")) != nil
    }
}
