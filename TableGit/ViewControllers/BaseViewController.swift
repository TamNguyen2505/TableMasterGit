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

    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupVM()
        observeTimer()
        
    }
    
    deinit {
      NotificationCenter.default.removeObserver(self, name: Notification.Name("SessionTimer"), object: nil)
    }
    
    //MARK: Helpers
    func setupUI() {
        
        view.backgroundColor = .white
        
    }
    
    func setupVM() {}
    
    private func observeTimer() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("SessionTimer"), object: nil)
        
    }
    
    @objc private func methodOfReceivedNotification(notification: NotificationCenter) {
        
        self.dismiss(animated: true, completion: nil)
        
    }

}
