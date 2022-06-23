//
//  FooterCollectionReusableView.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit

class FooterCollectionReusableView: UICollectionReusableView {
    //MARK: Properties
    private let choosePackagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Kết thúc chọn gói bảo hiểm"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "maskGroup72041")
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    //MARK: View cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Helpers
    private func setupUI() {
        
        addSubview(choosePackagesLabel)
        choosePackagesLabel.snp.makeConstraints{ make in
            
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(20)
            
        }
        
        addSubview(logoImageView)
        logoImageView.snp.makeConstraints{ make in
            
            make.top.equalTo(choosePackagesLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(125)
            make.height.equalTo(25)
            make.bottom.lessThanOrEqualToSuperview()
            
        }
        
    }
    
    func setContent(title: String) {
        self.choosePackagesLabel.text = title
        
    }
        
}
