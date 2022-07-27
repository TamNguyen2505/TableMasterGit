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
    
    struct SettingButton {
        
        var imageButton: UIImageView
        var titleButton: UILabel
        
    }
    
    private var settingButtons = [SettingButton]()
    
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
        
        contentView.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 120 / 2
        avatarImageView.snp.makeConstraints{ make in
            
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            make.bottom.equalToSuperview()
            
        }
        
        contentView.addSubview(uploadImageButton)
        uploadImageButton.snp.makeConstraints{ make in
            
            make.width.height.equalTo(45)
            make.top.equalTo(avatarImageView.snp.top)
            make.trailing.equalToSuperview().inset(20)
            
        }
        
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        
    }
    
    //MARK: Helpers
    private func createSingleButton(nameOfImageButton: String, nameOfButton: String, optionalButton: UIControl? = nil) -> UIView {
        
        let outView = UIView()
        outView.layer.cornerRadius = 5.0
        outView.layer.borderWidth = 1.0
        outView.layer.borderColor = UIColor.init(white: 0.5, alpha: 0.7).cgColor
        outView.layer.shadowColor = UIColor.init(white: 0.6, alpha: 0.5).cgColor
        outView.layer.shadowOffset = .init(width: 3, height: 3)
        outView.layer.shadowRadius = 4.0
        
        let buttonImageView = UIImageView()
        buttonImageView.image = UIImage(named: nameOfImageButton)
        
        let buttonNameTitle = UILabel()
        buttonNameTitle.font = UIFont.systemFont(ofSize: 14)
        buttonNameTitle.text = nameOfButton
        
        self.settingButtons.append(.init(imageButton: buttonImageView, titleButton: buttonNameTitle))
        
        let hStackHolder: UIStackView
        
        if let optionalButton = optionalButton {
            
            let hStack = UIStackView(arrangedSubviews: [buttonImageView, buttonNameTitle, optionalButton])
            hStack.axis = .horizontal
            hStackHolder = hStack
            
        } else {
            
            let arrowImageView = UIImageView()
            arrowImageView.image = UIImage(named: "next")
            
            let hStack = UIStackView(arrangedSubviews: [buttonImageView, buttonNameTitle, arrowImageView])
            hStack.axis = .horizontal
            hStackHolder = hStack
            
        }
        
        outView.addSubview(hStackHolder)
        hStackHolder.snp.makeConstraints { make in
            
            make.bottom.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(10)
            
        }
        
        return outView
        
    }
    
    
}
