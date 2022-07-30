//
//  UserDefaults + Extension.swift
//  TableGit
//
//  Created by MINERVA on 29/07/2022.
//

import Foundation

extension UserDefaults {
    
    enum Keys: String, CaseIterable {
        
        case isSavedLogin = "savedLogin"
        case fullName = "fullName"
        case userName = "userName"
        case jwtoken = "jwtoken"
        case pinCodeSoftOPT = "pinCodeSoftOPT"
        case tokenSeed = "tokenSeed"
        
    }
    
    static var userName: String {
        
        get {
            return UserDefaults.standard.string(forKey: Keys.userName.rawValue) ?? ""
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.userName.rawValue)
        }
        
    }
    
    static var isSavedLogin: Bool {
        
        get {
            return UserDefaults.standard.bool(forKey: Keys.isSavedLogin.rawValue)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: Keys.isSavedLogin.rawValue)
        }
        
    }
    
    static var tokenSeed: String {
        
        get {
            
            #if targetEnvironment(simulator)
            return UserDefaults.standard.string(forKey: Keys.tokenSeed.rawValue) ?? ""
            #else
            
            do {
                
                let key = try KeychainManager.shared.findPasswordInKeychains(key: Keys.tokenSeed.rawValue).password
                return key
                
            } catch {
                
                return ""
            }
            
            #endif
        }
        set {
            
            #if targetEnvironment(simulator)
            UserDefaults.standard.setValue(newValue, forKey: Keys.tokenSeed.rawValue)
            #else
            
            do {
                
                if !newValue.isEmpty {
                    try KeychainManager.shared.addPasswordToKeychains(key: Keys.tokenSeed.rawValue, password: newValue)
                    
                } else {
                    try KeychainManager.shared.deleteKeychain(key: Keys.tokenSeed.rawValue)
                    
                }
                
            } catch {
                
            }
            #endif
        }
        
    }
    
    static var jwtoken: String {
        
        get {
            
            #if targetEnvironment(simulator)
            return UserDefaults.standard.string(forKey: Keys.jwtoken.rawValue) ?? ""
            #else
            
            do {
                
                let key = try KeychainManager.shared.findPasswordInKeychains(key: Keys.jwtoken.rawValue).password
                return key
                
            } catch {
                
                return ""
            }
            
            #endif
        }
        set {
            
            #if targetEnvironment(simulator)
            UserDefaults.standard.setValue(newValue, forKey: Keys.jwtoken.rawValue)
            #else
            
            do {
                
                if !newValue.isEmpty {
                    try KeychainManager.shared.addPasswordToKeychains(key: Keys.jwtoken.rawValue, password: newValue)
                    
                } else {
                    try KeychainManager.shared.deleteKeychain(key: Keys.jwtoken.rawValue)
                    
                }
                
            } catch {
                
            }
            #endif
        }
        
    }
    
    static var pinCodeSoftOPT: String {
        
        get {
            
            #if targetEnvironment(simulator)
            return UserDefaults.standard.string(forKey: Keys.pinCodeSoftOPT.rawValue) ?? ""
            #else
            
            do {
                
                let key = try KeychainManager.shared.findPasswordInKeychains(key: Keys.pinCodeSoftOPT.rawValue).password
                return key
                
            } catch {
                
                return ""
            }
            
            #endif
        }
        set {
            
            #if targetEnvironment(simulator)
            UserDefaults.standard.setValue(newValue, forKey: Keys.pinCodeSoftOPT.rawValue)
            #else
            
            do {
                
                if !newValue.isEmpty {
                    try KeychainManager.shared.addPasswordToKeychains(key: Keys.pinCodeSoftOPT.rawValue, password: newValue)
                    
                } else {
                    try KeychainManager.shared.deleteKeychain(key: Keys.pinCodeSoftOPT.rawValue)
                    
                }
                
            } catch {
                
            }
            #endif
        }
        
    }
    
    
    
    
    
}
