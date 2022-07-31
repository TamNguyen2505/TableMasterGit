//
//  CircleGraphViewController.swift
//  TableGit
//
//  Created by MINERVA on 04/07/2022.
//

import UIKit

class VideoPlayerViewController: BaseViewController {
    //MARK: Properties
    private lazy var circleSlider: CustomCircleSlider = {
        let slider = CustomCircleSlider()
        slider.addTarget(self, action: #selector(handleEventFromCircleSlider(_:forEvent:)), for: .allEvents)
        return slider
    }()
        
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    //MARK: Helpers
    @objc func handleEventFromCircleSlider(_ sender: CustomCircleSlider, forEvent event: UIEvent) {
        
        guard let angle = sender.angle else {return}
        
        let delta = angle - 90
        let normalizedAngle: CGFloat
        
        if delta < 0 {
            
            normalizedAngle = 360 + delta
            
        } else {
            
            normalizedAngle = delta
            
        }
        
        let percentage = normalizedAngle / 360
        
        
    }
    
    //MARK: Helpers
    override func setupUI() {
        super.setupUI()
        
        view.backgroundColor = .white
        
        view.addSubview(circleSlider)
        circleSlider.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(250)
            
        }
        
        circleSlider.handleEventOfDidTapButton = { [weak self] (isPlayed) in
            guard let self = self else {return}
            
            
        }
        
  
        
    }
    
  
    
}



