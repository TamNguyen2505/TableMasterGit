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
    private let pinView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let thumbnailImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "component1461")
        iv.contentMode = .center
        return iv
    }()
    
    private lazy var gradientLayer: CAGradientLayer = {
        let startColor: UIColor = #colorLiteral(red: 0.3003244996, green: 0.9285392165, blue: 0.957008183, alpha: 0.2)
        let endColor: UIColor = #colorLiteral(red: 0.01771551371, green: 0.2268912196, blue: 0.9867611527, alpha: 0.3)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.type = .conic
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        
        gradientLayer.frame = bounds
        gradientLayer.colors = [startColor, endColor].map{ $0.cgColor}
        
        return gradientLayer
    }()
    
    private var previousPoint = CGPoint()
    private var angle: CGFloat?
    private var startAngle: CGFloat = 0
    private let lineWidth: CGFloat = 40

    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let midPointOfThumb = CGPoint(x: thumbnailImageView.frame.midX, y: thumbnailImageView.frame.midY)
        
        startAngle = getPointDistanceFromStart(to: midPointOfThumb)
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        createGradientLayer()
        
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        
        previousPoint = touch.location(in: self)
        
        let isTouchingImageView = thumbnailImageView.frame.contains(previousPoint)
        
        if isTouchingImageView {
            
            thumbnailImageView.backgroundColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 0.5)
            
        }
                
        return isTouchingImageView
        
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.continueTracking(touch, with: event)
        
        let touchPoint = touch.location(in: self)
        previousPoint = touchPoint
                
        if bounds.contains(previousPoint) {
            
            let origion = calculateNewXandNewY(to: touchPoint)
            thumbnailImageView.frame.origin = origion
            
            self.angle = getPointDistanceFromStart(to: touchPoint)
            setNeedsDisplay()
            
        }
        
        return true
        
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
                
        thumbnailImageView.backgroundColor = nil
        
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        addSubview(pinView)
        pinView.snp.makeConstraints{ make in
            
            make.edges.equalToSuperview().inset(lineWidth/2)
            
        }
        
        addSubview(thumbnailImageView)
        thumbnailImageView.snp.makeConstraints{ make in

            make.centerX.equalToSuperview()
            make.centerY.equalTo(pinView.snp.top)
            make.width.height.equalTo(40)

        }
        thumbnailImageView.layer.cornerRadius = 20
        pinView.isHidden = true
        
    }
    
    private func getPointDistanceFromStart(to point: CGPoint) -> CGFloat {
        
        var angle = radiansToDegrees(atan2(point.x - bounds.midX, point.y - bounds.midY))
        angle = (-angle.truncatingRemainder(dividingBy: 360.0) + 360 + 90).truncatingRemainder(dividingBy: 360)
        
        return angle
    }
    
    private func radiansToDegrees(_ angle: CGFloat) -> CGFloat {
        
        return angle / .pi * 180.0
        
    }
    
    private func calculateNewXandNewY(to point: CGPoint) -> CGPoint {
        
        let spinDegree = getPointDistanceFromStart(to: point)
        
        let sinAplha = sin(spinDegree * .pi / 180)
        let cosAlpha = cos(spinDegree * .pi / 180)
        
        let innerRadius = pinView.bounds.width / 2
        let outerRadius = bounds.width / 2
        
        let newX = innerRadius * cosAlpha + outerRadius - thumbnailImageView.bounds.width / 2
        let newY = innerRadius * sinAplha + outerRadius - thumbnailImageView.bounds.height / 2

        let point = CGPoint(x: newX, y: newY)
            
        return point
        
    }
    
    private func createGradientLayer() {
                
        guard let angle = angle else {return}
                
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = (bounds.width - lineWidth) / 2
        let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle * .pi / 180, endAngle: angle * .pi / 180, clockwise: true)
        
        let mask = CAShapeLayer()
        mask.fillColor = UIColor.clear.cgColor
        mask.strokeColor = UIColor.white.cgColor
        mask.lineWidth = lineWidth
        mask.path = path.cgPath
        gradientLayer.mask = mask
        layer.addSublayer(gradientLayer)
        
    }
    
}
