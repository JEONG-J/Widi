//
//  Keychain.swift
//  Widi
//
//  Created by Apple Coding machine on 5/29/25.
//

import Foundation
import Security

final class KeychainManager: @unchecked Sendable {
    static let standard = KeychainManager()
    
    private init() {}
    
    // MARK: - Raw Keychain Function
    @discardableResult
    private func save(_ data: Data, for key: String) -> Bool {
        if load(key: key) != nil {
            _ = delete(key: key)
        }
        
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data,
            kSecAttrAccessible: kSecAttrAccessibleWhenUnlocked
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("키체인 저장 실패: \(status) - \(SecCopyErrorMessageString(status, nil) ?? "알 수 없는 오류" as CFString)")
        }
        
        return status == errSecSuccess
    }
    
    private func load(key: String) -> Data? {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ]
        
        var item: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        if status != errSecSuccess {
            print("키체인 로드 실패: \(status) - \(SecCopyErrorMessageString(status, nil) ?? "알 수 없는 에러" as CFString)")
        }
        
        return item as? Data
    }
    
    @discardableResult
    private func delete(key: String) -> Bool {
        let query: [CFString: Any] = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            print("키 체인 삭제 실패: \(status) - \(SecCopyErrorMessageString(status, nil) ?? "Unknown error" as CFString)")
        }
        
        return status == errSecSuccess
    }
    
    // MARK: - UserMethod
    
    public func saveSession(_ session: UserKeychain, for key: String) -> Bool {
        guard let data = try? JSONEncoder().encode(session) else { return false }
        return save(data, for: key)
    }
    
    public func loadSession(for key: String) -> UserKeychain? {
        guard let data = load(key: key),
              let session = try? JSONDecoder().decode(UserKeychain.self, from: data) else { return nil }
        return session
    }
    
    public func deleteSession(for key: String) {
        _ = delete(key: key)
    }
}
