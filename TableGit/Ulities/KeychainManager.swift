//
//  KeychainManager.swift
//  TableGit
//
//  Created by MINERVA on 28/07/2022.
//

import LocalAuthentication

enum KeychainError: Error {
    
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    
}

enum KeychainKey: String {
    
    case JWT = "user-jwt"
    case SoftOTPPin = "soft-otp-pin"
    case TokenSeed = "token-seed"
    
}

class KeychainManager {
    //MARK: Properties
    static var shared = KeychainManager()
    private let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .userPresence, nil)
    private let server = Bundle.main.bundleIdentifier!
    private let context = LAContext()
    
    //MARK: Features
    func addPasswordToKeychains(key: KeychainKey, password: String) throws {
        
        if try findPasswordInKeychains(key: key).sucess {
            
            try updateNewPasswordForTheKeychain(key: key, newPassword: password)
            
        } else {
            
            var basicQuery = createBasicQuery(key: key)
            
            basicQuery.updateValue(password.data(using: .utf8)!, forKey: kSecValueData as String)
            
            let status = SecItemAdd(basicQuery as CFDictionary, nil)
            
            guard status == errSecSuccess else {throw KeychainError.unhandledError(status: status)}
                        
        }
        
    }
    
    func findPasswordInKeychains(key: KeychainKey) throws -> (sucess: Bool, password: String) {
        
        var basicQuery = createBasicQuery(key: key)
        
        basicQuery.updateValue(true, forKey: kSecReturnAttributes as String)
        basicQuery.updateValue(true, forKey: kSecReturnData as String)
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(basicQuery as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8)
                
        else {
            
            throw KeychainError.unexpectedPasswordData
        }
                
        return (true, password)
        
    }
    
    func updateNewPasswordForTheKeychain(key: KeychainKey, newPassword: String) throws {
        
        let basicQuery = createBasicQuery()

        let account = key.rawValue
        let password = newPassword.data(using: String.Encoding.utf8)!
        let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                         kSecValueData as String: password]
        
        let status = SecItemUpdate(basicQuery as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
                
    }
    
    func deleteKeychain(key: KeychainKey) throws {
        
        let basicQuery = createBasicQuery(key: key)
        
        let status = SecItemDelete(basicQuery as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
                
    }
    
    //MARK: Helpers
    private func createBasicQuery(key: KeychainKey? = nil) -> [String: Any] {
        
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecAttrServer as String: server]
        
        guard let key = key else {return query}

        query.updateValue(key.rawValue, forKey: kSecAttrAccount as String)
        
        return query
        
    }
    
}
