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
        
        if bounds.contains(previousPoint) {

//            let coordination = calculateOffset(x: touchPoint.x, y: touchPoint.y)
//            reconstraintThumb(x: coordination.offsetX, y: coordination.offsetY)
            
            let radiant = calculateRadiants(x: touchPoint.x, y: touchPoint.y)
            transform = CGAffineTransform(rotationAngle: radiant)
            
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
            
            centerXOfThumb = make.centerX.equalToSuperview().constraint
            centerYOfThumb = make.centerY.equalToSuperview().offset(bounds.height / 2).constraint
            make.width.height.equalTo(40)
            
        }
        thumbnailImageView.layer.cornerRadius = 20
        
    }
    
    private func calculateRadiants(x: CGFloat, y: CGFloat) -> CGFloat {
        
        let deltaX = x - bounds.midX
        let deltaY = y - bounds.midY
        
        let degree = x / bounds.width * 360
        
        let radiant = degree * .pi / 180
        
        return radiant
    }
    
    private func calculateOffset(x: CGFloat, y: CGFloat) -> (offsetX: CGFloat?, offsetY: CGFloat?) {
    
        let deltaX = x - bounds.midX
        let deltaY = y - bounds.midY
        
        guard abs(deltaX) > thumbnailImageView.bounds.height / 2 else {return (nil, nil)}
        
        let r = bounds.height / 2
        
        let cosAlpha = deltaX / r
        let sinAlpha = sqrt(1 - pow(cosAlpha, 2))
        
        var offsetX = abs(cosAlpha * r)
        var offsetY = abs(sinAlpha * r)
        
        if deltaX < 0, deltaY > 0 {
            
            offsetX = -offsetX
            
        } else if deltaX <= 0, deltaY >= 0 {
            
            offsetX = -offsetX
            offsetY = -offsetY
            
        } else if deltaX >= 0, deltaY <= 0 {
            
            offsetY = -offsetY
            
        } else {
            
            
            
        }
        
        return (offsetX, offsetY)
        
    }
    
    private func reconstraintThumb(x: CGFloat?, y: CGFloat?) {
        
        guard let x = x, let y = y else {return}
        
        thumbnailImageView.snp.remakeConstraints{ make in
            
            make.centerX.equalToSuperview().offset(x)
            make.centerY.equalToSuperview().offset(y)
            make.width.height.equalTo(40)
            
        }
        
    }

}
