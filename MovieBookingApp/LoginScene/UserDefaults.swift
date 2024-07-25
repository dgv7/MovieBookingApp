import Foundation

struct Booking: Codable {
    let bookingDate: Date
    let bookingNum: Int
    let bookingPrice: Double
    let bookingSeat: String
    let movieImage: String
    let movieTitle: String
}

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
    
// MARK: - Bookings 모델 데이터
/*
second entity = Bookings
 movieTitle
 movieImage
 bookingDate
 bookingNum
 bookingPrice
 bookingSeat
*/
    private let bookingsKey = "bookings"
/*
    saveBooking(_:):
    - Booking 객체를 받아 현재 로그인된 사용자의 예약 리스트에 추가
    - 예약 리스트는 이메일을 키로 하는 딕셔너리 형태로 저장됨
    - 예약 정보를 JSON으로 인코딩하여 UserDefaults에 저장(복잡한 데이터 구조는 CoreData를 사용해야함)
    getBookings():
    - UserDefaults에서 모든 예약 정보를 가져와 [String: [Booking]] 타입의 딕셔너리로 반환
    - 예약 정보가 없으면 빈 딕셔너리를 반환
    getBookings(for email:):
    - 특정 이메일에 대한 예약 리스트를 반환
    - 이메일에 해당하는 예약 정보가 없으면 빈 배열을 반환

    * 채웅님 변수명 연결
 let VC = ViewController()

  movieTitle = VC.reserveMoveNameLabel.text
  movieImage = VC.imageView. // 이건 구조 다시 봐야함
  bookingDate = VC.selectedDateTimeLabel.text
  bookingNum = VC.peopleCountLabel.text
  bookingPrice = VC.totalPriceLabel.text
  bookingSeat = VC.selectedSeatsLabel.text
*/
    
    // 에매 정보 저장
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
        // 특정 이메일에 대한 예약 정보 가져오ㄱ ㅣ
        func getBookings(for email: String) -> [Booking] {
            let bookings = getBookings()
            return bookings[email] ?? []
        }

}



