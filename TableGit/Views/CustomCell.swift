//
//  CustomCell.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit
import SnapKit

protocol CustomCelllDelegate: AnyObject {
    
    func deleteRow(from cell: CustomCell)
    func shouldResetUI(from cell: CustomCell)
    
}

class CustomCell: UITableViewCell {
    //MARK: Properties
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "A"
        label.numberOfLines = 0
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "CDB"
        label.numberOfLines = 0
        label.textAlignment = .right
        return label
    }()
    
    private let cardImageView: UIImageView = {
        let iv = UIImageView()
        iv.isUserInteractionEnabled = true
        
        let gifImage = UIImage.gifImageWithName("giphy")
        iv.image = gifImage
        
        return iv
    }()
    
    private lazy var dragToLeft: UISwipeGestureRecognizer = {
        let drag = UISwipeGestureRecognizer(target: self, action: #selector(handleEventDragLeft(_:)))
        drag.direction = .left
        return drag
    }()
    
    private lazy var dragToRight: UISwipeGestureRecognizer = {
        let drag = UISwipeGestureRecognizer(target: self, action: #selector(handleEventDragRight(_:)))
        drag.direction = .right
        return drag
    }()
    
    private let binView: UIView = {
        let view = UIView()
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 4.0
        view.layer.cornerRadius = 5.0
        view.isUserInteractionEnabled = true
        return view
    }()
    
    private let binImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "xoa")
        return iv
    }()
    
    private lazy var tapAtBin: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventFromTapBin(_:)))
        return tap
    }()
    
    weak var delegate: CustomCelllDelegate?
    private var isMoved = false
    private var leadingConstraint: Constraint!
    private var trailingConstraint: Constraint!
    
    //MARK: View cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetUIForCardView()
        
    }
    
    //MARK: Actions
    @objc func handleEventDragLeft(_ sender: UISwipeGestureRecognizer) {
 
        setupEventWhenCardMoved()
        
    }
    
    @objc func handleEventDragRight(_ sender: UISwipeGestureRecognizer) {
 
        resetUIForCardView()
        
    }
    
    @objc func handleEventFromTapBin(_ sender: UITapGestureRecognizer) {
 
        delegate?.deleteRow(from: self)
        binView.removeFromSuperview()
        
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        selectionStyle = .none
        
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{ make in
            
            make.top.equalToSuperview().offset(10)
            make.leading.equalToSuperview().offset(20)
            
        }
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        contentView.addSubview(messageLabel)
        messageLabel.snp.makeConstraints{ make in
            
            make.firstBaseline.equalTo(nameLabel.snp.firstBaseline)
            make.leading.equalTo(nameLabel.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(20)
            
        }
        messageLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        contentView.addSubview(cardImageView)
        cardImageView.snp.makeConstraints{ make in
            
            make.top.equalTo(messageLabel.snp.bottom).offset(16)
            make.bottom.equalToSuperview().inset(10)
            make.height.equalTo(200).priority(.high)
            
            leadingConstraint = make.leading.equalToSuperview().offset(20).constraint
            trailingConstraint = make.trailing.equalToSuperview().offset(-20).constraint
            
        }
        
        cardImageView.addGestureRecognizer(dragToLeft)
        cardImageView.addGestureRecognizer(dragToRight)
        
        layoutIfNeeded()
        
    }
    
    private func setupUIForBinView() {
        
        contentView.addSubview(binView)
        binView.snp.makeConstraints{ make in
            
            make.top.equalTo(cardImageView.snp.top)
            make.leading.equalTo(cardImageView.snp.trailing).offset(2)
            make.trailing.equalToSuperview().inset(20)
            make.bottom.equalTo(cardImageView.snp.bottom)
            
        }
        
        binView.addSubview(binImageView)
        binImageView.snp.makeConstraints{ make in
            
            make.center.equalToSuperview()
            make.width.height.equalTo(24)
            
        }
        
        binView.addGestureRecognizer(tapAtBin)
        
    }
    
    func resetUIForCardView() {
        
        guard isMoved == true else {return}
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            
            guard let self = self else {return}
            
            self.layoutIfNeeded()
            self.leadingConstraint.update(offset: 20)
            self.trailingConstraint.update(offset: -20)
            self.binView.removeFromSuperview()
            
        }
        
    }
    
    func setupEventWhenCardMoved() {
        
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, animations: {[weak self] in
            guard let self = self else {return}
            
            self.layoutIfNeeded()
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/3, animations: {
                self.leadingConstraint.update(offset: -20)
                self.trailingConstraint.update(offset: -60)
            })
            
            UIView.addKeyframe(withRelativeStartTime: 2/3, relativeDuration: 1/3, animations: {
                self.setupUIForBinView()
                
            })
            
        }, completion: { [weak self] _ in
            guard let self = self else {return}
            
            self.isMoved = true
            self.delegate?.shouldResetUI(from: self)
            
        })

    }
    
    func setupContent(name: String, message: String) {
    
        self.nameLabel.text = name
        self.messageLabel.text = message
        
    }
    
    func setupImage(image: UIImage?) {
        
        guard let image = image else {return}
        
        DispatchQueue.main.async {
            self.cardImageView.image = image
        }
        
    }

}

