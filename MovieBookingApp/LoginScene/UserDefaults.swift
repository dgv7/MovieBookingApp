//
//  UserDefaults.swift
//  MovieBookingApp
//
//  Created by t2023-m0119 on 7/22/24.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let credentialsKey = "credentials"
    
    private init() {}
    
    func saveCredentials(email: String, password: String) {
        var credentials = getCredentials()
        credentials[email] = password
        UserDefaults.standard.set(credentials, forKey: credentialsKey)
    }
    
    func getPassword(for email: String) -> String? {
        let credentials = getCredentials()
        return credentials[email]
    }
    
    private func getCredentials() -> [String: String] {
        return UserDefaults.standard.dictionary(forKey: credentialsKey) as? [String: String] ?? [:]
    }
}
