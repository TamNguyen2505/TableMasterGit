//
//  CircleGraphViewController.swift
//  TableGit
//
//  Created by MINERVA on 04/07/2022.
//

import UIKit

class CircleGraphViewController: UIViewController {
    //MARK: Properties
    private let circleSlider: CircleSlider = {
        let slider = CircleSlider()
        return slider
    }()
    

    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    
    //MARK: Helpers
    private func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(circleSlider)
        circleSlider.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(150)
            
        }
        
    }
    
    

}
