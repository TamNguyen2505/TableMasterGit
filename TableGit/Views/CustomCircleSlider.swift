//
//  CircleSlider.swift
//  TableGit
//
//  Created by MINERVA on 04/07/2022.
//

import UIKit
import SnapKit

class CustomCircleSlider: UIControl {
    //MARK: Properties
    private lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "component1513")
        iv.contentMode = .center
        return iv
    }()
    
    private var previousPoint = CGPoint()
    
    private var centerXOfThumb: Constraint!
    private var centerYOfThumb: Constraint!

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupUI()
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        previousPoint = touch.location(in: self)
        
        let isTouchingImageView = thumbnailImageView.frame.contains(previousPoint)
        thumbnailImageView.backgroundColor = #colorLiteral(red: 0.06444338986, green: 0.631372549, blue: 0.5324723758, alpha: 0.4)
                
        return isTouchingImageView
        
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let touchPoint = touch.location(in: self)
        previousPoint = touchPoint
        
        print(previousPoint)
        
        if bounds.contains(previousPoint) {
            
            let origion = calculateNewXandNewY(from: thumbnailImageView.frame.origin, to: touchPoint)
            thumbnailImageView.frame.origin = origion
            
        }
        
        return true
        
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
                
        thumbnailImageView.backgroundColor = nil
        
    }
    
    //MARK: Helpers
    private func setupUI() {
            
        layer.borderWidth = 2
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = bounds.width / 2
        
        addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints{ make in

            make.centerX.equalToSuperview()
            make.centerY.equalTo(self.snp.bottom)
            make.width.height.equalTo(40)

        }
        thumbnailImageView.layer.cornerRadius = 20
        
    }
    
    private func getPointDistanceFromStart(to point: CGPoint) -> CGFloat {
        
        var angle = radiansToDegrees(atan2(point.x - bounds.midX, point.y - bounds.midY))
        angle = (-angle.truncatingRemainder(dividingBy: 360.0) + 360 + 90).truncatingRemainder(dividingBy: 360)
                
        return angle
    }
    
    private func radiansToDegrees(_ angle: CGFloat) -> CGFloat {
        
        return angle / .pi * 180.0
        
    }
    
    private func calculateNewXandNewY(from oldPoint: CGPoint, to point: CGPoint) -> CGPoint {
        
        let spinDegree = getPointDistanceFromStart(to: point)
        
        let sinAplha = sin(spinDegree * .pi / 180)
        let cosAlpha = cos(spinDegree * .pi / 180)
        
        let radius = bounds.width / 2
        
        let newX = radius * cosAlpha + radius - thumbnailImageView.bounds.width / 2
        let newY = radius * sinAplha + radius - thumbnailImageView.bounds.height / 2

        let point = CGPoint(x: newX, y: newY)
            
        return point
        
    }
    
}
