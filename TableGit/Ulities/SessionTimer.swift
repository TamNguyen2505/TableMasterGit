//
//  Timer.swift
//  TableGit
//
//  Created by MINERVA on 18/07/2022.
//

import Foundation

public struct SessionTimer {
    //MARK: Properties
    public static let share = SessionTimer()
    public static var timer: Timer?
    public static var timeOut = false
    
    //MARK: Features
    public func setupTimer() {
        
        SessionTimer.timer?.invalidate()
        SessionTimer.timer = Timer.scheduledTimer(withTimeInterval: 5*60, repeats: false) { _ in
            
            SessionTimer.timeOut = true
            
        }
        
    }
    
    public func disableTimer() {
        
        SessionTimer.timer?.invalidate()
        
    }
    
}
