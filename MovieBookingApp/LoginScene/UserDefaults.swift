import Foundation

struct Booking: Codable {
    let bookingDate: String
    let bookingNum: Int
    let bookingPrice: Double
    let bookingSeat: String
    let movieImage: String
    let movieTitle: String
    let userId: UUID // UUID로 저장
}

class UserDefaultsManager {
    static let shared = UserDefaultsManager()   // 싱글톤 인스턴스로 전역에서 공유 가능
    private let credentialsKey = "credentials"
    private let currentEmailKey = "currentEmail"
    // MARK: - Bookings 모델 데이터
    private let bookingsKey = "bookings"
    
    private init() {}   // 외부에서 이 클래스 초기화 못하도록 설정
    
    // credentials를 가져오는 함수임. 빈 값은 빈 dict 반환
    private func getCredentials() -> [String: [String: String]] {
        return UserDefaults.standard.dictionary(forKey: credentialsKey) as? [String: [String: String]] ?? [:]
    }
    
    // 이메일, 비번, 닉네임, UUID 저장
    func saveCredentials(email: String, password: String, nickname: String, userId: UUID) {
        var credentials = getCredentials()
        credentials[email] = ["password": password, "nickname": nickname, "userId": userId.uuidString]   // 이메일 key를 기준으로 [비밀번호: 닉네임, UUID] value를 가지는 dict 업데이트
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
    
    // 저장된 dict에서 userId 반환
    func getUserId(for email: String) -> UUID? {
        let credentials = getCredentials()
        if let userIdString = credentials[email]?["userId"] {
            return UUID(uuidString: userIdString)
        }
        return nil
    }
    
    // 현재 로그인된 이메일 가져오기! Read / MyPageViewController에서만 사용됨
    func getEmail() -> String? {
        return UserDefaults.standard.string(forKey: currentEmailKey)
    }
    
    // 현재 이메일을 UserDefaults에 저장
    func setCurrentEmail(email: String) {
        UserDefaults.standard.set(email, forKey: currentEmailKey)
    }

    // 예약 정보 저장
    func saveBooking(_ booking: Booking) {
        var bookings = getBookings()
        if let email = getEmail() {
            var userBookings = bookings[email] ?? []
            userBookings.append(booking)
            bookings[email] = userBookings
            if let encoded = try? JSONEncoder().encode(bookings) {
                UserDefaults.standard.set(encoded, forKey: bookingsKey)
            }
        }
    }

    // 모든 예약 정보 가져오기
    func getBookings() -> [String: [Booking]] {
        if let data = UserDefaults.standard.data(forKey: bookingsKey),
           let bookings = try? JSONDecoder().decode([String: [Booking]].self, from: data) {
            return bookings
        }
        return [:]
    }

    // 특정 이메일에 대한 예약 정보 가져오기
    func getBookings(for email: String) -> [Booking] {
        let bookings = getBookings()
        return bookings[email] ?? []
    }
    
    // 예매 내역 삭제 기능 추가
    func deleteBooking(_ booking: Booking) {
        guard let email = getEmail() else { return }
        var bookings = getBookings()
        if var userBookings = bookings[email] {
            userBookings.removeAll { $0.bookingDate == booking.bookingDate && $0.movieTitle == booking.movieTitle }
            bookings[email] = userBookings
            if let encoded = try? JSONEncoder().encode(bookings) {
                UserDefaults.standard.set(encoded, forKey: bookingsKey)
            }
        }
    }

    // 이메일 업데이트
    func updateEmail(from oldEmail: String, to newEmail: String) {
        var credentials = getCredentials()
        if let oldData = credentials.removeValue(forKey: oldEmail) {
            credentials[newEmail] = oldData
            UserDefaults.standard.set(credentials, forKey: credentialsKey)
        }
        if let currentEmail = getEmail(), currentEmail == oldEmail {
            setCurrentEmail(email: newEmail)
        }
    }

    // 비밀번호 업데이트
    func updatePassword(for email: String, to newPassword: String) {
        var credentials = getCredentials()
        if var userData = credentials[email] {
            userData["password"] = newPassword
            credentials[email] = userData
            UserDefaults.standard.set(credentials, forKey: credentialsKey)
        }
    }
}
