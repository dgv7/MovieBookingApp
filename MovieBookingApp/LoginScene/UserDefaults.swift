import Foundation


// UserDefaults.standard.set() -> create, update
// UserDefaults.standard.string(forKey: "") -> read
// UserDefaults.standard.removeObject(forKey: "") -> delete

class UserDefaultsManager {
    static let shared = UserDefaultsManager()   // 싱글톤 인스턴스로 전역에서 공유 가능
    private let credentialsKey = "credentials"
    private let currentEmailKey = "currentEmail"
    
    private init() {}   // 외부에서 이 클래스 초기화 못하도록 설정
    
    // credentials를 가져오는 함수임. 빈 값은 빈 dict 반환
    private func getCredentials() -> [String: [String:String]] {
        return UserDefaults.standard.dictionary(forKey: credentialsKey) as? [String: [String:String]] ?? [:]
    }
    // 이메일, 비번, 닉네임 저장
    func saveCredentials(email: String, password: String, nickname: String) {
        var credentials = getCredentials()
        credentials[email] = ["password": password, "nickname": nickname]   // 이메일 key를 기준으로 [비밀번호: 닉네임] value를 가지는 dict 업데이트
        UserDefaults.standard.set(credentials, forKey: credentialsKey)  // 업데이트된 내용 저장
        setCurrentEmail(email: email)   // 현재 사용된 이메일 별도 저장
    }
    
    // 저장된 dict에서 password 반환
    func getPassword(for email: String) -> String? {
        let credentials = getCredentials()
        return credentials[email]?["password"]
    }
    // 저장된 dict에서 nickname 반환
    func getNickname(for email: String) -> String? {
        let credentials = getCredentials()
        return credentials[email]?["nickname"]
    }
    // 현재 로그인된 이메일 가져오기! Read / MyPageViewController에서만 사용됨
    func getEmail() -> String? {
        return UserDefaults.standard.string(forKey: currentEmailKey)
    }
    // 현재 이메일을 UserDefaults에 저장
    private func setCurrentEmail(email: String) {
        UserDefaults.standard.set(email, forKey: currentEmailKey)
    }
}
