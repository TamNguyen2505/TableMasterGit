//
//  RecordInformationViewController.swift
//  TableGit
//
//  Created by MINERVA on 10/08/2022.
//

import UIKit
import WebKit

class RecordInformationViewController: BaseViewController {
    //MARK: Properties
    private lazy var recordImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(named: "signup-background")
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var recordTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "recordTitle"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = UIColor.white
        
        guard let recordTitle = recordTitle else {return label}
        label.text = recordTitle
        
        return label
    }()
    
    private let artistImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "signup-background")
        return iv
    }()
    
    private let infomationArtistLabel: UILabel = {
        let label = UILabel()
        label.text = "information"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    private let webview: WKWebView = {
        let webview = WKWebView()
        webview.scrollView.showsVerticalScrollIndicator = false
        webview.scrollView.showsHorizontalScrollIndicator = false
        return webview
    }()
    
    var personid: Int?
    var recordImageURL: URL?
    var recordTitle: String?
    
    private let viewModel = RecordInfomationViewModel()
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        Loader.shared.show()
        
        hideTabBarController(hide: true)
        
        view.addSubview(recordImageView)
        recordImageView.snp.makeConstraints{ make in
            
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(250)
            
        }
        
        recordImageView.addSubview(recordTitleLabel)
        recordTitleLabel.snp.makeConstraints{ make in
            
            make.leading.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.trailing.greaterThanOrEqualToSuperview()
            
        }
        
        let hStack = UIStackView(arrangedSubviews: [artistImageView, infomationArtistLabel])
        hStack.spacing = 10
        hStack.axis = .horizontal
        
        view.addSubview(hStack)
        hStack.snp.makeConstraints{ make in
            
            make.top.equalTo(recordImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(10)
            
        }
        
        artistImageView.snp.makeConstraints{ make in
            
            make.width.height.equalTo(80)
            
        }
        
        view.addSubview(webview)
        webview.snp.makeConstraints{ make in
            
            make.top.equalTo(hStack.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
                        
    }
    
    override func observeVM() {
        super.observeVM()
        
        self.observation = viewModel.observe(\.didGetAllHardvardPersonalInformation, options: [.new]) { [weak self] _,_ in
            guard let self = self else {return}
            
            DispatchQueue.main.async {
            
                guard let urlRequest = self.viewModel.createExhibitionURLOfPerson() else {return}
                self.webview.load(urlRequest)
                
            }
            
        }
        
//        self.observation = viewModel.observe(\.didGetImage, options: [.new]) { [weak self] (_, key) in
//            guard let self = self else {return}
//
//            DispatchQueue.main.async {
//            
//                self.recordImageView.image = key.newValue as? UIImage
//                
//                Loader.shared.hide()
//                
//            }
//            
//        }
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        Task {
            
            guard let personid = personid else {return}

            try await viewModel.getPersonalInformationModel(personID: personid)
            
        }
        
        Task {
            
            guard let recordImageURL = recordImageURL else {return}

            await viewModel.getRecordImage(with: recordImageURL)
            
        }
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        hideTabBarController(hide: false)
        
    }
    
    //MARK: Helpers
    
    
}
