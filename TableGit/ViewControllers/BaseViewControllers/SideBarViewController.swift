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
        
        headerType = .headerWithMiddleTitle
        
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
