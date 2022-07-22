//
//  LoginViewController.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit

class LoginViewController: BaseViewController {
    //MARK: Properties
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "login-background")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let topGradientCurvedView: TopGradientCurvedView = {
        let view = TopGradientCurvedView()
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "default-avatar")
        iv.layer.borderWidth = 1
        iv.layer.borderColor = UIColor.lightGray.cgColor
        return iv
    }()
    
    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        return tf
    }()
    
    private lazy var loginButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("LOG IN", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.backgroundColor = .systemOrange
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleEventFromLogInButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var signupButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("SIGN UP", for: .normal)
        btn.setTitleColor(UIColor.systemOrange, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.layer.borderWidth = 2
        btn.layer.borderColor = UIColor.systemOrange.cgColor
        btn.layer.cornerRadius = 5
        btn.addTarget(self, action: #selector(handleEventFromSignUpButton(_:)), for: .touchUpInside)
        return btn
    }()
        
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    
    //MARK: Actions
    @objc func handleEventFromLogInButton(_ sender: UIButton) {
                
        if networkMonitor.status == .satisfied {
            
            let targetVC = BaseTabBarController()
            targetVC.modalPresentationStyle = .fullScreen
            self.present(targetVC, animated: true, completion: nil)
            
        } else {
            
            showAlertView()
            
        }
                
    }
    
    
    @objc func handleEventFromSignUpButton(_ sender: UIButton) {
        
        let targetVC = SignUpViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
    
    //MARK: Helpers
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints{ make in
            
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
        view.addSubview(avatarImageView)
        avatarImageView.layer.cornerRadius = 120 / 2
        avatarImageView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(120)
            
        }
        
        view.addSubview(topGradientCurvedView)
        topGradientCurvedView.snp.makeConstraints{ make in
            
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(avatarImageView.snp.bottom)
            
        }
        view.bringSubviewToFront(avatarImageView)
        
        let vStackForTextField = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField])
        vStackForTextField.axis = .vertical
        vStackForTextField.spacing = 10
        vStackForTextField.distribution = .fillEqually
        
        view.addSubview(vStackForTextField)
        vStackForTextField.snp.makeConstraints{ make in
            
            make.top.equalTo(avatarImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        usernameTextField.snp.makeConstraints{ make in
            
            make.height.equalTo(50)
            
        }
        
        let hStackForButton = UIStackView(arrangedSubviews: [loginButton, signupButton])
        hStackForButton.axis = .horizontal
        hStackForButton.spacing = 10
        hStackForButton.distribution = .fillEqually
        
        view.addSubview(hStackForButton)
        hStackForButton.snp.makeConstraints{ make in
            
            make.top.equalTo(vStackForTextField.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        loginButton.snp.makeConstraints{ make in
            
            make.height.equalTo(50)
            make.width.equalTo(signupButton.snp.width)
            
        }
        
    }
    
    private func showAlertView() {
        
        let alert = UIAlertController(title: "Notification", message: "Please check the Internet Access", preferredStyle: .alert)
        
        let open = UIAlertAction(title: "Settings", style: .default) { _ in
            
            guard let settingUrl = URL(string: UIApplication.openSettingsURLString) else {return}
            
            if UIApplication.shared.canOpenURL(settingUrl) {
                
                UIApplication.shared.open(settingUrl, options: [:], completionHandler: nil)
                
            }
            
        }
        alert.addAction(open)
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
}
