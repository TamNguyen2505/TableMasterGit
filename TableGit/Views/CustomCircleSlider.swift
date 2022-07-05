//
//  CircleSlider.swift
//  TableGit
//
//  Created by MINERVA on 04/07/2022.
//

import UIKit

class CustomCircleSlider: UIControl {
    //MARK: Properties
    private lazy var thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "component1513")
        iv.contentMode = .center
        return iv
    }()
    
    private var previousPoint = CGPoint()

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
            
        thumbnailImageView.backgroundColor = #colorLiteral(red: 0.06444338986, green: 0.631372549, blue: 0.5324723758, alpha: 0.4)
                
        return isTouchingImageView
        
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let touchPoint = touch.location(in: self)
        previousPoint = touchPoint
        
        if bounds.contains(previousPoint) {
            
            
            
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
        
        addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints{ make in
            
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.height.equalTo(40)
            
        }
        thumbnailImageView.layer.cornerRadius = 20
        
        
        
    }

}
