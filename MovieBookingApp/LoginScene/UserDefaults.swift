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
    static let shared = UserDefaultsManager()
    private let credentialsKey = "credentials"
    private let currentEmailKey = "currentEmail"
    private let currentUserIdKey = "currentUserId"
    private let bookingsKey = "bookings"

    private init() {}

    private func getCredentials() -> [String: [String: String]] {
        return UserDefaults.standard.dictionary(forKey: credentialsKey) as? [String: [String: String]] ?? [:]
    }

    func saveCredentials(email: String, password: String, nickname: String, userId: UUID) {
        var credentials = getCredentials()
        credentials[email] = ["password": password, "nickname": nickname, "userId": userId.uuidString]
        UserDefaults.standard.set(credentials, forKey: credentialsKey)
        setCurrentEmail(email: email)
        setCurrentUserId(userId: userId)
    }

    func getPassword(for email: String) -> String? {
        let credentials = getCredentials()
        return credentials[email]?["password"]
    }

    func getNickname(for email: String) -> String? {
        let credentials = getCredentials()
        return credentials[email]?["nickname"]
    }

    func getUserId(for email: String) -> UUID? {
        let credentials = getCredentials()
        if let userIdString = credentials[email]?["userId"] {
            return UUID(uuidString: userIdString)
        }
        return nil
    }

    func getEmail() -> String? {
        return UserDefaults.standard.string(forKey: currentEmailKey)
    }

    func getCurrentUserId() -> UUID? {
        if let userIdString = UserDefaults.standard.string(forKey: currentUserIdKey) {
            return UUID(uuidString: userIdString)
        }
        return nil
    }

    private func setCurrentEmail(email: String) {
        UserDefaults.standard.set(email, forKey: currentEmailKey)
    }

    private func setCurrentUserId(userId: UUID) {
        UserDefaults.standard.set(userId.uuidString, forKey: currentUserIdKey)
    }

    func saveBooking(_ booking: Booking) {
        var bookings = getBookings()
        if let userId = getCurrentUserId() {
            var userBookings = bookings[userId.uuidString] ?? []
            userBookings.append(booking)
            bookings[userId.uuidString] = userBookings
            if let encoded = try? JSONEncoder().encode(bookings) {
                UserDefaults.standard.set(encoded, forKey: bookingsKey)
            }
        }
    }

    func getBookings() -> [String: [Booking]] {
        if let data = UserDefaults.standard.data(forKey: bookingsKey),
           let bookings = try? JSONDecoder().decode([String: [Booking]].self, from: data) {
            return bookings
        }
        return [:]
    }

    func getBookings(for userId: UUID) -> [Booking] {
        let bookings = getBookings()
        return bookings[userId.uuidString] ?? []
    }

    func deleteBooking(_ booking: Booking) {
        guard let userId = getCurrentUserId() else { return }
        var bookings = getBookings()
        if var userBookings = bookings[userId.uuidString] {
            userBookings.removeAll { $0.bookingDate == booking.bookingDate && $0.movieTitle == booking.movieTitle }
            bookings[userId.uuidString] = userBookings
            if let encoded = try? JSONEncoder().encode(bookings) {
                UserDefaults.standard.set(encoded, forKey: bookingsKey)
            }
        }
    }

    func updateEmail(from oldEmail: String, to newEmail: String) {
        var credentials = getCredentials()
        if let userInfo = credentials.removeValue(forKey: oldEmail) {
            credentials[newEmail] = userInfo
            UserDefaults.standard.set(credentials, forKey: credentialsKey)
        }
        setCurrentEmail(email: newEmail)
    }

    func updatePassword(for email: String, to newPassword: String) {
        var credentials = getCredentials()
        if var userInfo = credentials[email] {
            userInfo["password"] = newPassword
            credentials[email] = userInfo
            UserDefaults.standard.set(credentials, forKey: credentialsKey)
        }
    }
    // 로그아웃시 데이터 read 정보 삭제 -> 현재 not working
    func clearUserData() {
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "nickname")
            UserDefaults.standard.removeObject(forKey: "userId")
            UserDefaults.standard.synchronize()
        }
}
