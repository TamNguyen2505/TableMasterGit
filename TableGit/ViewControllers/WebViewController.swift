//
//  WebViewController.swift
//  TableGit
//
//  Created by MINERVA on 28/06/2022.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    //MARK: Properties
    private lazy var webView: WKWebView = {
        let web = WKWebView()
        web.scrollView.showsHorizontalScrollIndicator = false
        web.scrollView.showsVerticalScrollIndicator = false
        web.scrollView.indicatorStyle = .white
        web.scrollView.bounces = false
        web.scrollView.delegate = self
        return web
    }()
    
    private lazy var verticalSlide: VerticalSlider = {
        let slide = VerticalSlider()
        slide.addTarget(self, action: #selector(handleEventFromSlider(_:)), for: .touchDragInside)
        return slide
    }()
    
    var urlRequest: URLRequest?
    
    private let group = DispatchGroup()
    private let globalQueue = DispatchQueue.global(qos: .userInteractive)
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadContentForWeb(url: "https://en.wikipedia.org/wiki/Transformation_matrix#Perspective_projection")
        
        group.notify(queue: .main) {[weak self] in
            guard let self = self else {return}
            
            self.setupUI()
            
        }
        
    }
    
    //MARK: Actions
    @objc func handleEventFromSlider(_ sender: VerticalSlider) {
        
        let percentage = sender.topOffsetOfThumb / (sender.bounds.height - sender.thumbnailImageViewHeight)
        let invisibleHeightContent = webView.scrollView.contentSize.height - webView.bounds.height
        let offsetY = percentage * invisibleHeightContent
        let rect = CGRect(x: 0, y: offsetY, width: webView.bounds.width, height: webView.bounds.height)
        
        self.webView.scrollView.scrollRectToVisible(rect, animated: true)
    }

    //MARK: Helpers
    private func setupUI() {
        
        view.backgroundColor = .white
        
        view.addSubview(webView)
        webView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(100)
            
        }
        
        view.addSubview(verticalSlide)
        verticalSlide.snp.makeConstraints{ make in
            
            make.top.equalTo(webView.snp.top)
            make.leading.equalTo(webView.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(webView.snp.bottom)
            
        }

    }
    
    private func loadContentForWeb(url: String) {
        
        guard let url = URL(string: url) else {return}
        
        group.enter()
        
        globalQueue.async(group: group) { [weak self] in
            guard let self = self else {return}
            defer{self.group.leave()}
            let request = URLRequest(url: url)
                        
            DispatchQueue.main.async {

                self.webView.load(request)
                
            }
            
        }
        
    }

}

//MARK: UIScrollViewDelegate
extension WebViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
                
        let invisibleHeightContent = webView.scrollView.contentSize.height - webView.bounds.height
        let percentage = scrollView.contentOffset.y / invisibleHeightContent
        let topOffset = percentage * (verticalSlide.bounds.height - verticalSlide.thumbnailImageViewHeight)
        
        guard !self.webView.isLoading, !self.verticalSlide.isTouchInside else {return}
        
        verticalSlide.topOffsetOfThumb = topOffset
        
    }
    
    
}
