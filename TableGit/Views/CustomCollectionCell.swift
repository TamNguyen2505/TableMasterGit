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
        label.numberOfLines = 4
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
            make.leading.trailing.equalToSuperview().inset(5)
            make.width.height.equalTo(250)
            
        }
        
        let vStack = UIStackView(arrangedSubviews: [titleImageViewLabel, artistLabel])
        vStack.spacing = 5
        vStack.axis = .vertical
        
        contentView.addSubview(vStack)
        vStack.snp.makeConstraints{ make in
            
            make.top.equalTo(artImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(5)
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
    
    func transformToLarge() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0) { [weak self] in
            guard let self = self else {return}
            
            self.artImageView.transform = CGAffineTransform.init(scaleX: 1.1, y: 1.1)
            self.artImageView.layer.borderColor = UIColor.systemYellow.cgColor
            self.artImageView.layer.borderWidth = 5
            
        }
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
    }
    
    func transformToStandard() {
        
        UIView.animate(withDuration: 0.2, delay: 0.0) { [weak self] in
            guard let self = self else {return}
            
            self.artImageView.transform = .identity
            self.artImageView.layer.borderWidth = 0
            
        }
        
    }
    
}
