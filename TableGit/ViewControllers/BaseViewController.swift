//
//  BaseViewController.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 16/07/2022.
//

import UIKit

class BaseViewController: UIViewController {
    //MARK: Properties

    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupVM()
        
    }
    
    //MARK: Helpers
    func setupUI() {
        
        view.backgroundColor = .white
        
    }
    
    func setupVM() {}
    

}
