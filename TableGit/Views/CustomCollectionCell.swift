//
//  CustomCollectionCell.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import SnapKit

class CustomCollectionCell: UICollectionViewCell {
    //MARK: Properties
    private let artImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        return iv
    }()
    
    private let titleImageViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
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
        
        contentView.addSubview(artImageView)
        artImageView.snp.makeConstraints{ make in
            
            make.top.equalToSuperview().offset(5)
            make.leading.trailing.equalToSuperview().inset(20)
            make.width.equalTo(UIScreen.main.bounds.width - 40)
            make.height.equalTo(200)
            
        }
        
        let vStack = UIStackView(arrangedSubviews: [titleImageViewLabel, artistLabel])
        vStack.spacing = 5
        vStack.axis = .vertical
        
        contentView.addSubview(vStack)
        vStack.snp.makeConstraints{ make in
            
            make.top.equalTo(artImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            
        }
        
    }
    
    func setupContent(titleImage: String, artist: String) {
        
        self.titleImageViewLabel.text = titleImage
        self.artistLabel.text = artist
        
    }
    
    func setupImage(image: UIImage?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            
            self.artImageView.image = image
            
        }
                
    }
    
}
