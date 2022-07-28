//
//  KeychainManager.swift
//  TableGit
//
//  Created by MINERVA on 28/07/2022.
//

import LocalAuthentication

struct Credentials {
    
    var username: String
    var password: String
    
}

enum KeychainError: Error {
    
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    
}

class KeychainManager {
    //MARK: Properties
    private let access = SecAccessControlCreateWithFlags(nil, kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly, .userPresence, nil)
    private let server = "www.example.com"
    private let context = LAContext()
    
    //MARK: Features
    func addPasswordToKeychains() throws -> Bool {
                
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: UserDefault.username,
                                    kSecAttrServer as String: server,
                                    kSecAttrAccessControl as String: access as Any,
                                    kSecUseAuthenticationContext as String: context,
                                    kSecValueData as String: UserDefault.password.data(using: .utf8)!]
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {throw KeychainError.unhandledError(status: status)}
        
        return true
        
    }
    
    func findPasswordInKeychains() throws -> (sucess: Bool, credentials: Credentials?) {
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true,
                                    kSecUseAuthenticationContext as String: context]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: String.Encoding.utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
                
        else {
            
            throw KeychainError.unexpectedPasswordData
        }
        
        let credentials = Credentials(username: account, password: password)
        
        return (true, credentials)
        
    }
    
    func updateNewPasswordForTheKeychain(credentials: Credentials) throws -> Bool {
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: server,
                                    kSecUseAuthenticationContext as String: context]

        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)!
        let attributes: [String: Any] = [kSecAttrAccount as String: account,
                                         kSecValueData as String: password]
        
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        
        return true
        
    }
    
    func deleteKeychain(credentials: Credentials) throws -> Bool {
        
        let account = credentials.username
        let password = credentials.password.data(using: String.Encoding.utf8)!
        
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecAttrServer as String: server,
                                    kSecAttrAccount as String: account,
                                    kSecValueData as String: password,
                                    kSecUseAuthenticationContext as String: context]
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
        
        return true
        
    }
    
}
