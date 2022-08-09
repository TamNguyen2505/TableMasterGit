//
//  HomeCollectionView.swift
//  TableGit
//
//  Created by MINERVA on 09/08/2022.
//

import UIKit

class HomeCollectionView: UICollectionViewCell {
    //MARK: Properties
    private let artImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 5
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "signup-background")
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
                        
        contentView.addSubview(artImageView)
        artImageView.snp.makeConstraints{ make in
        
            make.edges.equalToSuperview().inset(5)
                        
        }
                        
    }
    
    func setupImage(image: UIImage?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            
            self.artImageView.image = image
            
        }
                
    }
    
}
