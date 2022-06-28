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
        web.navigationDelegate = self
        return web
    }()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        loadContentForWeb()

    }
    

    //MARK: Helpers
    private func setupUI() {
        
        view.addSubview(webView)
        webView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(100)
            
        }
        
    }
    
    private func loadContentForWeb() {
        
        guard let url = URL(string: "https://ebanking.scb.com.vn/term/URLBAOLONG.htm") else {return}
        let request = URLRequest(url: url)
        
        self.webView.load(request)
        
    }

}

extension WebViewController: WKNavigationDelegate {
    
    
    
}
