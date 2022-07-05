//
//  FooterTableView.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit

protocol FooterTableViewDelegate: AnyObject {
    
    func didTapCancelButton(from view: FooterTableView)
    func didTapContinueButton(from view: FooterTableView)
    
}

class FooterTableView: UITableViewHeaderFooterView {
    //MARK: Properties
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("CHART", for: .normal)
        btn.backgroundColor = UIColor(white: 0.6, alpha: 0.8)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(handleEventFromCancelButton(_:)), for: .touchUpInside)
        return btn
    }()
    
    private lazy var continueButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("CARD", for: .normal)
        btn.backgroundColor = UIColor(white: 0.6, alpha: 0.8)
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(handleEventFromContinueButton(_:)), for: .touchUpInside)
        return btn
    }()

    weak var delegate: FooterTableViewDelegate?
    
    //MARK: View cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func handleEventFromCancelButton(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.blue
        delegate?.didTapCancelButton(from: self)
        
    }
    
    @objc func handleEventFromContinueButton(_ sender: UIButton) {
        
        sender.backgroundColor = UIColor.blue
        delegate?.didTapContinueButton(from: self)
        
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        addSubview(cancelButton)
        cancelButton.snp.makeConstraints{ make in
            
            make.top.leading.equalToSuperview().offset(20)
            make.height.equalTo(50)
            
        }
        
        addSubview(continueButton)
        continueButton.snp.makeConstraints{ make in
            
            make.top.equalTo(cancelButton.snp.top)
            make.leading.equalTo(cancelButton.snp.trailing).offset(20)
            make.trailing.bottom.equalToSuperview().inset(20)
            make.height.equalTo(50)
            make.width.equalTo(cancelButton.snp.width)
            
        }
        
 
    }


}
