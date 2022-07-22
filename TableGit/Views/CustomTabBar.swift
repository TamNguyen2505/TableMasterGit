//
//  CustomTabBar.swift
//  TableGit
//
//  Created by MINERVA on 21/07/2022.
//

import UIKit

class CustomTabBar: UIView {
    //MARK: Properties
    var itemTapped: ((_ tab: Int) -> Void)?
    var activeItem: Int = 0
    private var imageArray = [UIImageView]()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(menuItems: [TabItem], frame: CGRect) {
        self.init(frame: frame)
        
        backgroundColor = .white
        
        for index in 0..<menuItems.count {
            
            let itemWidth = frame.width / CGFloat(menuItems.count)
            let offsetX = itemWidth * CGFloat(index)
            
            let itemView = createTabItem(item: menuItems[index])
            itemView.clipsToBounds = true
            itemView.tag = index
            
            addSubview(itemView)
            itemView.snp.makeConstraints{ make in
                
                make.width.equalTo(itemWidth)
                make.height.equalToSuperview()
                make.leading.equalToSuperview().offset(offsetX)
                make.top.equalToSuperview()
                
            }
            
        }
        
        setNeedsLayout()
        layoutIfNeeded()
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setLayerForActiveTab(tab: 0)
        highlightImageView(iv: self.imageArray[0])
        
    }
    
    //MARK: Actions
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        
        guard let toTag = sender.view?.tag else {return}
        
        switchTab(from: activeItem, to: toTag)
        
    }
    
    //MARK: Helpers
    func createTabItem(item: TabItem) -> UIView {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        
        let tabBarItem = UIView()
        tabBarItem.layer.backgroundColor = UIColor.clear.cgColor
        tabBarItem.clipsToBounds = true
        tabBarItem.addGestureRecognizer(tap)
        tabBarItem.backgroundColor = #colorLiteral(red: 0.9823524356, green: 0.7392255664, blue: 0.4647747874, alpha: 1)
        
        let itemTitleLabel = UILabel()
        itemTitleLabel.text = item.displayTitle
        itemTitleLabel.textAlignment = .center
        itemTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        let itemImageView = UIImageView()
        itemImageView.image = item.icon?.withRenderingMode(.automatic)
        itemImageView.clipsToBounds = true
        self.imageArray.append(itemImageView)

        tabBarItem.addSubview(itemTitleLabel)
        tabBarItem.addSubview(itemImageView)
        
        itemImageView.snp.makeConstraints{ make in
            
            make.height.width.equalTo(32)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(8)
            
        }
        
        itemTitleLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(itemImageView.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
            make.bottom.greaterThanOrEqualToSuperview().inset(8)
            
        }
        
        return tabBarItem
        
    }
    
    func switchTab(from: Int, to: Int) {
        
        let delta = from - to
    
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            
            if abs(delta) == 1 {
                
                self.animateForAdjacentTabs(from: from, to: to)
                
            } else {
                
                self.animateForFarTabs(from: from, to: to, delta: delta)
                
            }
            
            
        }
        
    }
    
    func animateForFarTabs(from: Int, to: Int, delta: Int) {
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: [.calculationModeCubicPaced]) {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/4) {
                
                self.removeLayerForDeactiveTab(tab: from)
                self.turnOffHighlightImageView(iv: self.imageArray[from])
                
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/4, relativeDuration: 1/4) {
                
                if delta < -1 {
                    
                    for index in (from + 1)..<to {
                        
                        self.setLayerForActiveTab(tab: index)
                        
                    }
                    
                } else if delta > 1 {
                    
                    for index in (from - 1)...(to + 1) {
                        
                        self.setLayerForActiveTab(tab: index)
                        
                    }
                    
                }
   
            }

            UIView.addKeyframe(withRelativeStartTime: 2/4, relativeDuration: 1/4) {
                
                if delta < -1 {
                    
                    for index in (from + 1)..<to {
                        
                        self.removeLayerForDeactiveTab(tab: index)
                        
                    }
                    
                } else if delta > 1 {
                    
                    for index in (from - 1)...(to + 1) {
                        
                        self.removeLayerForDeactiveTab(tab: index)
                        
                    }
                    
                }
                
            }
            
            UIView.addKeyframe(withRelativeStartTime: 3/4, relativeDuration: 1/4) {
                
                self.setLayerForActiveTab(tab: to)
                self.highlightImageView(iv: self.imageArray[to])
                
            }
            
            
        }
        
        
    }
    
    func animateForAdjacentTabs(from: Int, to: Int) {
        
        UIView.animateKeyframes(withDuration: 0.25, delay: 0.0, options: [.calculationModeCubicPaced]) {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1/2) {
                
                self.removeLayerForDeactiveTab(tab: from)
                self.turnOffHighlightImageView(iv: self.imageArray[from])
                
            }
            
            UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2) {
                
                self.setLayerForActiveTab(tab: to)
                self.highlightImageView(iv: self.imageArray[to])
                
            }
            
            
        } completion: { _ in
            
        }
        
        
    }
    
    func setLayerForActiveTab(tab: Int) {
        
        let tabToActive = subviews[tab]
        tabToActive.backgroundColor = .clear

        let borderLayer = CAShapeLayer()

        borderLayer.name = "Active Border"
        borderLayer.path = createPath(inside: tabToActive)
        borderLayer.fillColor = #colorLiteral(red: 0.9823524356, green: 0.7392255664, blue: 0.4647747874, alpha: 1).cgColor
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}

            UIView.animate(withDuration: 0.0,
                           delay: 0.0,
                           options: [.transitionCrossDissolve]) {
                
                tabToActive.layer.insertSublayer(borderLayer, at: 0)
                tabToActive.setNeedsLayout()
                tabToActive.layoutIfNeeded()
                
            } completion: { _ in
                
                self.itemTapped?(tab)
                self.activeItem = tab
                
            }

        }
        
    }
    
    func removeLayerForDeactiveTab(tab: Int) {
        
        let inactiveTab = subviews[tab]
        inactiveTab.backgroundColor = #colorLiteral(red: 0.9823524356, green: 0.7392255664, blue: 0.4647747874, alpha: 1)
        
        let layerRemove = inactiveTab.layer.sublayers?.filter{$0.name == "Active Border"}
        
        DispatchQueue.main.async {
            
            UIView.animate(withDuration: 0.0,
                           delay: 0.0,
                           options: [.transitionCrossDissolve]) {
                
                layerRemove?.forEach{$0.removeFromSuperlayer()}
                inactiveTab.setNeedsLayout()
                inactiveTab.layoutIfNeeded()
                
            }
            
        }
        
    }
    
    func createPath(inside view: UIView) -> CGPath {
        
        let path = UIBezierPath()
        let width = view.frame.width
        let height = view.frame.height
        let centerWidth = width / 2
        let offsetY = 0.0
        
        path.move(to: .init(x: 0, y: offsetY))
        path.addLine(to: .init(x: width / 10  , y: offsetY))
        
        path.addCurve(to: .init(x: centerWidth, y: height * 3.2/5),
                      controlPoint1: .init(x: width * 2/10, y: offsetY),
                      controlPoint2: .init(x: width * 3/10, y: height * 3.2/5))
        
        path.addCurve(to: .init(x: width * 9/10, y: offsetY),
                      controlPoint1: .init(x: width * 7/10, y: height * 3.2/5),
                      controlPoint2: .init(x: width * 8/10, y: offsetY))
        
        path.addLine(to: .init(x: width, y: offsetY))
        path.addLine(to: .init(x: width, y: height))
        path.addLine(to: .init(x: 0, y: height))
        
        path.close()
        
        return path.cgPath
        
    }
    
    private func highlightImageView(iv: UIImageView) {
        
        iv.transform = CGAffineTransform.init(translationX: 0, y: -6)
        iv.layer.cornerRadius = iv.frame.width / 2
        iv.layer.backgroundColor = #colorLiteral(red: 0.400059551, green: 0.6795784831, blue: 0.3747661114, alpha: 1).cgColor
        iv.layer.borderColor = #colorLiteral(red: 0.2170224165, green: 0.6795784831, blue: 0.1666197622, alpha: 1).cgColor
        iv.layer.borderWidth = 1

    }
    
    private func turnOffHighlightImageView(iv: UIImageView) {
        
        iv.transform = .identity
        iv.layer.cornerRadius = 0
        iv.layer.backgroundColor = UIColor.clear.cgColor
        iv.layer.borderColor = UIColor.clear.cgColor
        iv.layer.borderWidth = 0
        
    }
    
    
}
