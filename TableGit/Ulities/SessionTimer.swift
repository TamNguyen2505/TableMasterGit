//
//  Timer.swift
//  TableGit
//
//  Created by MINERVA on 18/07/2022.
//

import Foundation
import UIKit

public struct SessionTimer {
    //MARK: Properties
    public static let share = SessionTimer()
    public static var timer: Timer?
    public static var timeOut = false
    
    //MARK: Features
    public func setupTimer() {
        
        SessionTimer.timer?.invalidate()
        SessionTimer.timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            
            NotificationCenter.default.post(name: Notification.Name("SessionTimer"), object: nil)
            
        }
        
    }
    
    public func disableTimer() {
        
        SessionTimer.timer?.invalidate()
        
    }
    
}
