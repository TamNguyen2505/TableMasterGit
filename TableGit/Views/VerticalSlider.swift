//
//  VerticalSlider.swift
//  TableGit
//
//  Created by MINERVA on 01/07/2022.
//

import UIKit
import SnapKit

class VerticalSlider: UIControl {
    //MARK: Properrties
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "component1513")
        iv.contentMode = .center
        return iv
    }()
    
    private var topConstraint: Constraint!
    private var previousPoint = CGPoint()
    
    var thumbnailImageViewHeight: CGFloat {
        return thumbnailImageView.bounds.height
    }
    
    var topOffsetGetter: CGFloat = 0
    var topOffsetSetter: CGFloat = 0 {
        didSet{
            animateConstraintTop(topOffsetSetter)
        }
    }
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        previousPoint = touch.location(in: self)
        
        let isTouchingImageView = thumbnailImageView.frame.contains(previousPoint)
            
        thumbnailImageView.backgroundColor = #colorLiteral(red: 0.631372549, green: 0.1523510218, blue: 0.1466061771, alpha: 0.4)
                
        return isTouchingImageView
        
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let touchPoint = touch.location(in: self)
        previousPoint = touchPoint
        
        if bounds.contains(previousPoint) {
            
            let offset = offsetValue(touchPoint.y)
            
            animateConstraintTop(offset)
            
        }
        
        return true
        
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
                
        thumbnailImageView.backgroundColor = nil
        
    }
    
    
    //MARK: Helpers
    private func setupUI() {
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 20
        
        addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints{ make in
            
            topConstraint = make.top.equalToSuperview().constraint
            make.leading.trailing.equalToSuperview()
            make.width.height.equalTo(40)
            
        }
        thumbnailImageView.layer.cornerRadius = 20
        
    }
    
    private func offsetValue(_ value: CGFloat) -> CGFloat {
        
        if value <= thumbnailImageViewHeight {
            
            self.topOffsetGetter = 0
            
            return 0
            
        } else if value >= bounds.height - thumbnailImageViewHeight {
            
            self.topOffsetGetter = bounds.height
            
            return bounds.height - thumbnailImageViewHeight
            
        } else {
            
            self.topOffsetGetter = value
            
            return value
            
        }
        
    }
    
    private func animateConstraintTop(_ value: CGFloat) {
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else {return}
            
            self.topConstraint.update(offset: value)
            self.layoutIfNeeded()
            
        }
    
    }
    

}
