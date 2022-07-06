//
//  CircleGraphViewController.swift
//  TableGit
//
//  Created by MINERVA on 04/07/2022.
//

import UIKit

class CircleGraphViewController: UIViewController {
    //MARK: Properties
    private lazy var circleSlider: CustomCircleSlider = {
        let slider = CustomCircleSlider()
        slider.addTarget(self, action: #selector(handleEventFromCircleSlider(_:forEvent:)), for: .allEvents)
        return slider
    }()
    
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
            
            setupUI()
            
  }
        
    //MARK: Helpers
    @objc func handleEventFromCircleSlider(_ sender: CustomCircleSlider, forEvent event: UIEvent) {
    }
        
    //MARK: Helpers
    private func setupUI() {
            
            view.backgroundColor = .white
            
            view.addSubview(circleSlider)
            circleSlider.snp.makeConstraints{ make in
                
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                make.centerX.equalToSuperview()
                make.width.height.equalTo(300)
                
            }
            
        }
    
}
    

