//
//  BaseTabBarController.swift
//  TableGit
//
//  Created by MINERVA on 21/07/2022.
//

import UIKit

class BaseTabBarController: UITabBarController {
    //MARK: Properties
    var customTabBar: CustomTabBar?
    var tabBarHeight: CGFloat = 75.0
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadTabBar()
        
    }
    
    
    //MARK: Helpers
    func loadTabBar() {
                
        let tabbarItems: [TabItem] = [.home, .news, .settings]
        
        setupCustomTabMenu(tabbarItems) { [weak self] viewControllers in
            guard let self = self else {return}
            
            self.viewControllers = viewControllers
            
        }
        
    }
    
    func setupCustomTabMenu(_ menuItems: [TabItem], completion: @escaping ([UIViewController]) -> Void) {
        
        let frame = tabBar.frame
        var controllers = [UIViewController]()
        
        tabBar.isHidden = true
        
        let customTabBar = CustomTabBar(menuItems: menuItems, frame: frame)
        self.customTabBar = customTabBar
        
        customTabBar.clipsToBounds = true
        customTabBar.itemTapped = changeTab(tab:)
        
        view.backgroundColor = .clear
        view.addSubview(customTabBar)
        customTabBar.snp.makeConstraints{ make in
            
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(tabBarHeight)
            
        }
        
        menuItems.forEach{controllers.append($0.viewController)}
        
        view.layoutIfNeeded()
        completion(controllers)
        
    }

    func changeTab(tab: Int) {
        
        self.selectedIndex = tab
        
    }
 
}

