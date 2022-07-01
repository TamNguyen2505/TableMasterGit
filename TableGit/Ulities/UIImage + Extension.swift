//
//  UIImage + Extension.swift
//  TableGit
//
//  Created by MINERVA on 01/07/2022.
//

import UIKit

extension UIImage {
    
    func rotate(radians: CGFloat) -> UIImage {
        
        let transform = CGAffineTransform(rotationAngle: radians)
        let rotatedSize = CGRect(origin: .zero, size: size).applying(transform).integral.size
        
        UIGraphicsBeginImageContext(rotatedSize)
        
        guard let context = UIGraphicsGetCurrentContext() else {return self}
        let origin = CGPoint(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        
        context.translateBy(x: origin.x, y: origin.y)
        context.rotate(by: radians)
        
        let rect = CGRect(x: -origin.y, y: -origin.x, width: size.width, height: size.height)
        draw(in: rect)
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage ?? self
        
    }
    
    
}
