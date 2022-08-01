//
//  BaseViewController.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit

class BaseViewController: UIViewController {
    //MARK: Properties
    let networkMonitor = NetworkMonitor.shared

    enum HeaderType {
        
    case noHeader, headerWidthRightSlideBarAndMiddleTitleAndLeftAvatar
    
    }
    var headerType: HeaderType = .noHeader {
        didSet{
            setupUIForHeaderView()
        }
    }
    private lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupUIForHeaderView()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupVM()
        observeTimer()
        
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self, name: Notification.Name("SessionTimer"), object: nil)
    }
    
    //MARK: Actions
    @objc func handleEventFromSideBar() {
        
        let targetVC = SideBarViewController()
        
        slideInTransitioningDelegate.direction = .left
        targetVC.transitioningDelegate = slideInTransitioningDelegate
        targetVC.modalPresentationStyle = .custom
        targetVC.delegate = self
        
        self.present(targetVC, animated: true, completion: nil)
        
    }
    
    //MARK: Helpers
    func setupUI() {
        
        view.backgroundColor = .white
        
    }
    
    func setupUIForHeaderView() {
        
        switch headerType {
            
        case .noHeader:
            break
            
        case .headerWidthRightSlideBarAndMiddleTitleAndLeftAvatar:
            setupUIForHeaderWidthRightSlideBarAndMiddleTitleAndLeftAvatar()
            break
            
        }
        
    }
    
    func setupVM() {}
    
    private func observeTimer() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("SessionTimer"), object: nil)
        
    }
    
    @objc private func methodOfReceivedNotification(notification: NotificationCenter) {
        
        AppDelegate.switchToLoginViewController()

    }

}

//MARK: Functions used for setupUIForHeaderView
extension BaseViewController {
    
    private func setupUIForHeaderWidthRightSlideBarAndMiddleTitleAndLeftAvatar() {
        
        let slideBarImageView = UIImageView()
        slideBarImageView.image = UIImage(named: "icons8-menu")?.resize(targetSize: .init(width: 40, height: 40))
        slideBarImageView.contentMode = .scaleAspectFit
        slideBarImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventFromSideBar))
        slideBarImageView.addGestureRecognizer(tap)
        
        let titleNavigationLabel = UILabel()
        
        let attributesLineOne: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        let lineOne = NSMutableAttributedString(string: "Welcome to\n", attributes: attributesLineOne)
        
        let attributesLineTwo: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18),
                                                                .foregroundColor: UIColor.systemRed]
        let lineTwo = NSMutableAttributedString(string: "Art World", attributes: attributesLineTwo)
        
        let totalString: NSMutableAttributedString = lineOne
        totalString.append(lineTwo)
        
        titleNavigationLabel.attributedText = totalString
        titleNavigationLabel.textAlignment = .center
        titleNavigationLabel.numberOfLines = 0
        
        let avatarImageView = UIImageView()
        avatarImageView.image = UIImage(named: "default-avatar")?.resize(targetSize: .init(width: 40, height: 40))
        avatarImageView.contentMode = .scaleAspectFit
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: slideBarImageView)
        self.navigationItem.titleView = titleNavigationLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarImageView)
        
    }
    
    
}

//MARK: SideBarViewControllerDelegate
extension BaseViewController: SideBarViewControllerDelegate {
    
    func handleEventFromLogoutButton(from vc: SideBarViewController) {
        
        AppDelegate.switchToLoginViewController()
        
    }
    
}
