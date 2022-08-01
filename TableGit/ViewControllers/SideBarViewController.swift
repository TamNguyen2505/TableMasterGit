//
//  SideBarViewController.swift
//  TableGit
//
//  Created by MINERVA on 29/07/2022.
//

import UIKit

protocol SideBarViewControllerDelegate: AnyObject {
    
    func handleEventFromLogoutButton(from vc: SideBarViewController)
    
}

class SideBarViewController: BaseViewController {
    //MARK: Properties
    private let titleNavigationLabel: UILabel = {
        let label = UILabel()
        
        let attributesLineOne: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        let lineOne = NSMutableAttributedString(string: "Welcome to\n", attributes: attributesLineOne)
        
        let attributesLineTwo: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18),
                                                                .foregroundColor: UIColor.systemRed]
        let lineTwo = NSMutableAttributedString(string: "Art World", attributes: attributesLineTwo)
        
        let totalString: NSMutableAttributedString = lineOne
        totalString.append(lineTwo)
        
        label.attributedText = totalString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        
        let image = UIImage(named: "logout")?.rotate(radians: -.pi / 2)
        button.setImage(image, for: .normal)
        button.setTitle("LOG OUT", for: .normal)
        button.setTitleColor(UIColor.systemRed, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleEventFromLogOutButton(_:)), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: SideBarViewControllerDelegate?
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
                
        view.addSubview(titleNavigationLabel)
        titleNavigationLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            
        }
        
        view.addSubview(logOutButton)
        logOutButton.snp.makeConstraints{ make in
            
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
        
        
    }
    
    
    //MARK: Actions
    @objc func handleEventFromLogOutButton(_ sender: UIButton) {
        
        self.delegate?.handleEventFromLogoutButton(from: self)
        
    }
    
    
    
}
