//
//  String + Extension.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import Foundation

extension String {
    
    public static func className(aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
}
