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
        
        blurView.isHidden = true
        activeIndicator.layer.cornerRadius = 25
        
    }

    //MARK: Methods
    func show() {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let strongSelf = self else { return }
            
            let keyWindow = UIApplication.shared.keyWindow
            keyWindow?.addSubview(strongSelf.blurView)
            strongSelf.blurView.frame = keyWindow?.frame ?? CGRect()
            
            strongSelf.setupUIForActiveIndicator()
            
        })
        
    }

    func hide() {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.blurView.removeFromSuperview()
            strongSelf.activeIndicator.removeFromSuperview()
            
        })
    }
    
    func showInView(view: UIView) {
        DispatchQueue.main.async(execute: { [weak self] in
            guard let strongSelf = self else { return }
            
            view.addSubview(strongSelf.blurView)
            strongSelf.blurView.frame = view.frame
            
            strongSelf.setupUIForActiveIndicator()
            
        })
    }
    
}
