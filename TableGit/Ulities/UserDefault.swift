//
//  UserDefault.swift
//  TableGit
//
//  Created by MINERVA on 28/07/2022.
//

import Foundation

struct UserDefault {
    
    static var username: String {
        get {
            return UserDefaults.value(forKey: "username") as! String
        }
        
        set {
            UserDefaults.setValue(newValue, forKey: "username")
        }
        
    }
    
    static var password: String {
        get {
            return UserDefaults.value(forKey: "password") as! String
        }
        
        set {
            UserDefaults.setValue(newValue, forKey: "password")
        }
        
    }
    
}
