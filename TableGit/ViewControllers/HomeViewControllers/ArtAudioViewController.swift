//
//  ArtAudioViewController.swift
//  TableGit
//
//  Created by MINERVA on 08/08/2022.
//

import UIKit
import AVFoundation

class ArtAudioViewController: BaseViewController {
    //MARK: Properties
    private let artImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.layer.cornerRadius = 5.0
        return iv
    }()
    
    private var audioPlayer: AVAudioPlayer?
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        view.addSubview(artImageView)
        artImageView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            
        }
        
        
    }
    
    
    
}
