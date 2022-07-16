//
//  LoginViewController.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit

class LoginViewController: UIViewController {
    //MARK: Properties
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "login-background")
        iv.contentMode = .scaleAspectFit
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
    @objc func handleEventFromSignUpButton(_ sender: UIButton) {
        
        let targetVC = SignUpViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
    
    //MARK: Helpers
    private func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints{ make in
            
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
        let vStackForTextField = UIStackView(arrangedSubviews: [usernameTextField, passwordTextField])
        vStackForTextField.axis = .vertical
        vStackForTextField.spacing = 10
        vStackForTextField.distribution = .fillEqually
        
        view.addSubview(vStackForTextField)
        vStackForTextField.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
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
    


}
