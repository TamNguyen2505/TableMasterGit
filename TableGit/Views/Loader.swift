//
//  Loader.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 25/06/2022.
//
import UIKit

public final class Loader {
    //MARK: Properties
    public static let shared = Loader()
    
    private let blurView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.2, alpha: 0.2)
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let activeIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView()
        av.color = UIColor.systemGreen
        av.backgroundColor = UIColor.white
        av.style = .large
        av.startAnimating()
        return av
    }()
    
    //MARK: Helper
    private func setupUIForActiveIndicator() {
        
        blurView.addSubview(activeIndicator)
        activeIndicator.snp.makeConstraints{ make in

            make.center.equalToSuperview()
            make.width.height.equalTo(50)

        }
        
        activeIndicator.layer.cornerRadius = 25
        
    }

    //MARK: Methods
    func show() {
        
        guard let keyWindow = UIApplication.shared.connectedScenes.flatMap({ ($0 as? UIWindowScene)?.windows ?? [] }).first, keyWindow.isKeyWindow else {return}
        
        keyWindow.addSubview(blurView)
        blurView.frame = keyWindow.frame
        
        setupUIForActiveIndicator()
        
        
    }

    func hide() {
        
        blurView.removeFromSuperview()
        activeIndicator.removeFromSuperview()

    }
    
    func showInView(view: UIView) {
        
        view.addSubview(blurView)
        blurView.frame = view.frame
        
        setupUIForActiveIndicator()

    }
    
}
