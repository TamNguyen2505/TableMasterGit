//
//  BaseNavigationController.swift
//  TableGit
//
//  Created by MINERVA on 12/08/2022.
//

import UIKit

class BaseNavigationController: UINavigationController {
    //MARK: Properties
    
    

    //MARK: View cycle
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        delegate = self
        
    }
    
    //MARK: Actions
    @objc func handleEventFromLeftItem(_ sender: UIButton) {
        
    }
    
    @objc func handleEventFromRightItem(_ sender: UIButton) {
        
    }
    
    //MARK: Helpers
    private func setupUIForLeftItem(leftImageName: String, leftTitle: String? = nil , tag: Int = 0) -> UIView {
                
        let leftItem = UIButton()
        leftItem.addTarget(self, action: #selector(handleEventFromLeftItem(_:)), for: .allEvents)
        leftItem.setImage(.init(named: leftImageName)?.resize(targetSize: .init(width: 40, height: 40)), for: .normal)
        leftItem.setTitle(leftTitle, for: .normal)
        leftItem.setTitleColor(UIColor.systemRed, for: .normal)
        leftItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        leftItem.tag = tag
        
        return leftItem
        
    }
    
    private func setupUIForTitle(titleName: String, attribuedTitle: [NSAttributedString.Key: Any]? = nil) -> UIView {
        
        let title = UILabel()
        title.textAlignment = .center
        
        if let attribuedTitle = attribuedTitle {
            
            title.attributedText = NSMutableAttributedString(string: titleName, attributes: attribuedTitle)
            return title
            
        } else {
            
            title.font = UIFont.boldSystemFont(ofSize: 18)
            return title
            
        }
        
    }
    
    private func setupUIForRightItem(rightImageName: String, rightTitlte: String? = nil, tag: Int = 0) -> UIView {
                
        let rightItem = UIButton()
        rightItem.addTarget(self, action: #selector(handleEventFromRightItem(_:)), for: .allEvents)
        rightItem.setImage(.init(named: rightImageName)?.resize(targetSize: .init(width: 40, height: 40)), for: .normal)
        rightItem.setTitle(rightTitlte, for: .normal)
        rightItem.setTitleColor(UIColor.systemRed, for: .normal)
        rightItem.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        return rightItem
        
    }
    
    private func setupStackForItems(views: [UIView]) -> UIView {
        
        let stackView = UIStackView(arrangedSubviews: views)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillProportionally
        
        return stackView
        
    }

}

extension BaseNavigationController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        viewController.navigationItem.setHidesBackButton(true, animated: false)
        
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
      
        let nameOfViewController = viewController.className
        
        if nameOfViewController == LoginViewController.className {
            
            
            
            
        }
        
    }
    
}
