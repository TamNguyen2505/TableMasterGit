//
//  MyApplication.swift
//  TableGit
//
//  Created by MINERVA on 18/07/2022.
//

import UIKit

@objc(MyApplication)

class MyApplication: UIApplication {

    override func sendEvent(_ event: UIEvent) {
        
        if event.type != .touches {
            
            super.sendEvent(event)
            return
            
        }
        
        var restartTimer = true
        
        if let touches = event.allTouches {
            
            for touch in touches.enumerated() {
                
                if touch.element.phase != .cancelled && touch.element.phase != .ended {
                    
                    restartTimer = false
                    break
                    
                }
                
            }
            
        }
        
        if restartTimer {
            
            SessionTimer.share.setupTimer()
            print("setupTimer")
            
        } else {
            
            
        }
        
        super.sendEvent(event)
        
    }
    
}
