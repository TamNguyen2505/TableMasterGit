//
//  CustomCollectionCell.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import SnapKit

class ArtCollectionCell: UICollectionViewCell {
    //MARK: Properties
    private let artImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "signup-background")
        return iv
    }()
    
    private let titleImageViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.numberOfLines = 3
        label.textColor = .darkGray
        return label
    }()
    
    private let artistLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 5
        label.textColor = .lightGray
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
                        
        let vStack = UIStackView(arrangedSubviews: [artImageView, titleImageViewLabel, artistLabel])
        vStack.spacing = 10
        vStack.setCustomSpacing(20, after: artImageView)
        vStack.axis = .vertical
        
        contentView.addSubview(vStack)
        vStack.snp.makeConstraints{ make in
            
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalToSuperview()
            
        }
                
        artImageView.snp.makeConstraints{ make in
        
            make.height.equalTo(250)
            make.leading.trailing.equalToSuperview()
                        
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
