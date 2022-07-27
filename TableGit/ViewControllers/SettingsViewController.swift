//
//  SettingsViewController.swift
//  TableGit
//
//  Created by MINERVA on 22/07/2022.
//

import UIKit

class SettingsViewController: BaseViewController {
    //MARK: Properties
    private let scrollView: UIScrollView = {
        let width = UIScreen.main.bounds.width
        let height = CGFloat.greatestFiniteMagnitude
        
        let view = UIScrollView()
        view.contentSize = CGSize(width: width, height: height)
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "default-avatar")
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    }()
    
    private lazy var uploadImageButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        btn.tintColor = #colorLiteral(red: 0.1597932875, green: 0.253477037, blue: 0.4077349007, alpha: 1)
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 2
        btn.layer.borderColor = #colorLiteral(red: 0.1597932875, green: 0.253477037, blue: 0.4077349007, alpha: 1).cgColor
        btn.scalesLargeContentImage = true
        return btn
    }()
    
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints{ make in
            
            make.edges.width.equalToSuperview()
            
        }
        
        
        
    }
    
}
