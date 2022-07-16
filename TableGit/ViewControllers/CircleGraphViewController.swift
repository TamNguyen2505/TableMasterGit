//
//  CircleGraphViewController.swift
//  TableGit
//
//  Created by MINERVA on 04/07/2022.
//

import UIKit
import youtube_ios_player_helper

class CircleGraphViewController: BaseViewController {
    //MARK: Properties
    private lazy var circleSlider: CustomCircleSlider = {
        let slider = CustomCircleSlider()
        slider.addTarget(self, action: #selector(handleEventFromCircleSlider(_:forEvent:)), for: .allEvents)
        return slider
    }()
    
    private lazy var youtubeView: YTPlayerView = {
        let view = YTPlayerView()
        view.delegate = self
        return view
    }()
    
    private lazy var duration = youtubeView.duration()
    
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
        let second = percentage * duration
        
        self.youtubeView.loadVideo(byId: "h_xLRrwDric", startSeconds: Float(second), suggestedQuality: .auto)
        
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
            
            self.playOrPauseVideo(isPlayed: isPlayed)
            
        }
        
        view.addSubview(youtubeView)
        youtubeView.snp.makeConstraints{ make in
            
            make.top.equalTo(circleSlider.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            
        }
        
        
        self.youtubeView.load(withVideoId: "S7ElVoYZN0g")
        
    }
    
    private func playOrPauseVideo(isPlayed: Bool) {
        
        if isPlayed {
            
            self.youtubeView.playVideo()
            
        } else {
            
            self.youtubeView.pauseVideo()
            
        }
        
    }
    
}

extension CircleGraphViewController: YTPlayerViewDelegate {
    
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {
        
        guard !self.circleSlider.isTouchInside else {return}
        
        let timePercentage = Double(playTime) / duration
        let roundTime = round(timePercentage * 100) / 100
        
        circleSlider.setSliderFromOutside = roundTime
        
    }
    
}

