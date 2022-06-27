//
//  CustomCollectionCell.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit
import SnapKit

class CustomCollectionCell: UICollectionViewCell {
    //MARK: Properties
    private let cardImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let indexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let addView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 4.0
        view.layer.cornerRadius = 5.0
        view.isUserInteractionEnabled = true
        return view
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
        
        contentView.addSubview(cardImageView)
        cardImageView.snp.makeConstraints{ make in

            make.top.equalToSuperview()
            make.width.equalTo(150).priority(.high)
            make.height.equalTo(75).priority(.high)
            make.leading.trailing.equalToSuperview()
            
        }
        
        contentView.addSubview(indexLabel)
        indexLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(cardImageView.snp.bottom).offset(10)
            make.leading.equalTo(cardImageView.snp.leading)
            make.trailing.equalTo(cardImageView.snp.trailing)
            make.bottom.equalToSuperview()
        
        }
        
    }
    
    
    func setupContent(image: UIImage?, index: String) {
        self.cardImageView.image = image
        self.indexLabel.text = index
        
    }
}
