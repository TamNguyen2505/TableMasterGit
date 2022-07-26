//
//  CustomCollectionReusableView.swift
//  TableGit
//
//  Created by MINERVA on 26/07/2022.
//

import UIKit

class CustomCollectionReusableView: UICollectionReusableView {
    //MARK: Properties
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.text = "label"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    //MARK: Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        addSubview(totalLabel)
        totalLabel.snp.makeConstraints{ make in
            
            make.top.leading.equalToSuperview().offset(20)
            make.trailing.bottom.equalToSuperview()
            
        }
        
    }
    
    func updateContent(title: String) {
        
        self.totalLabel.text = title
        
    }
        
}
