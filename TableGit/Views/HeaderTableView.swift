//
//  HeaderTableView.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit
import SnapKit

class HeaderTableView: UITableViewHeaderFooterView {
    
    //MARK: Properties
    private let choosePackagesLabel: UILabel = {
        let label = UILabel()
        label.text = "Chọn gói bảo hiểm"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let addImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "maskGroup71874")
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 2.0
        iv.layer.cornerRadius = 5.0
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private let shuffleImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "shuffle.circle.fill")
        iv.tintColor = UIColor.systemGreen
        iv.layer.borderColor = UIColor.lightGray.cgColor
        iv.layer.borderWidth = 2.0
        iv.layer.cornerRadius = 5.0
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var collectionLayout: UICollectionViewFlowLayout = {
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: sectionInsetLeft, bottom: 0, right: sectionInsetRight)
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 30
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(CustomCollectionCell.self, forCellWithReuseIdentifier: CustomCollectionCell.className)
        collection.register(HeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.className)
        collection.register(FooterCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.className)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()
    
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
        return av
    }()
    
    private lazy var oneTapOnAdd: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventOneTapOnAdd(_:)))
        return tap
    }()
    
    private lazy var oneTapOnShuffle: UITapGestureRecognizer = {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventOneTapOnShuffle(_:)))
        return tap
    }()
    
    private let sectionInsetLeft = 20.0
    private let sectionInsetRight = 20.0
    
    //MARK: View cycle
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupUIForActiveIndicator()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Actions
    @objc func handleEventOneTapOnAdd(_ sender: UISwipeGestureRecognizer) {
        
        configureActiveIndicator(shouldAdd: true)
        
        collectionData[0].imageArray.insert(imageInsert, at: 0)
        let indexPath = IndexPath(item: 0, section: 0)
        let rect = CGRect(origin: .zero, size: .init(width: collectionView.bounds.width, height: collectionView.bounds.height))
        
        UIView.animateKeyframes(withDuration: 1, delay: 0, animations: {[weak self] in
            guard let self = self else {return}
            
            self.layoutIfNeeded()
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1/2, animations: {
                self.collectionView.scrollRectToVisible(rect, animated: false)
                
            })
            
            UIView.addKeyframe(withRelativeStartTime: 1/2, relativeDuration: 1/2, animations: {
                self.collectionView.insertItems(at: [indexPath])
                
            })
            
            let visibleIndex = self.collectionView.indexPathsForVisibleItems
            self.collectionView.reloadItems(at: visibleIndex)
            
        }, completion: { [weak self] _ in
            guard let self = self else {return}
            
            self.collectionLayout.invalidateLayout()
            self.configureActiveIndicator(shouldAdd: false)
            
        })
 
    }
    
    @objc func handleEventOneTapOnShuffle(_ sender: UISwipeGestureRecognizer) {
        
        configureActiveIndicator(shouldAdd: true)
        
        collectionData.swapAt(0, 1)
        let rect = CGRect(origin: .zero, size: .init(width: collectionView.bounds.width, height: collectionView.bounds.height))
        
        collectionView.performBatchUpdates {

            self.collectionView.moveSection(0, toSection: 1)
            self.collectionView.reloadData()

        } completion: { [weak self] _ in
            guard let self = self else {return}

            self.collectionView.scrollRectToVisible(rect, animated: false)
            self.configureActiveIndicator(shouldAdd: false)

        }
 
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        contentView.addSubview(choosePackagesLabel)
        choosePackagesLabel.snp.makeConstraints{ make in
            
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().inset(20)
            
        }
        
        let hStack = UIStackView(arrangedSubviews: [shuffleImageView, addImageView])
        hStack.axis = .horizontal
        hStack.spacing = 5
        hStack.distribution = .fillEqually
        
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints{ make in
            
            make.centerY.equalTo(choosePackagesLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualTo(choosePackagesLabel.snp.trailing)
            
        }
        hStack.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        shuffleImageView.snp.makeConstraints{ make in
            
            make.width.height.equalTo(40)
            
        }
        
        addImageView.addGestureRecognizer(oneTapOnAdd)
        shuffleImageView.addGestureRecognizer(oneTapOnShuffle)
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints{ make in
            
            make.top.equalTo(hStack.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(120)
            
        }
 
    }
    
    private func setupUIForActiveIndicator() {
        
        addSubview(blurView)
        blurView.snp.makeConstraints{ make in
            
            make.edges.equalTo(collectionView.snp.edges)
            
        }

        blurView.addSubview(activeIndicator)
        activeIndicator.snp.makeConstraints{ make in

            make.center.equalToSuperview()
            make.width.height.equalTo(50)

        }
        
        blurView.isHidden = true
        activeIndicator.layer.cornerRadius = 25
        
    }
    
    private func configureActiveIndicator(shouldAdd: Bool) {
        
        if shouldAdd {
            
            blurView.isHidden = false
            activeIndicator.startAnimating()
            
        } else {
    
            activeIndicator.stopAnimating()
            blurView.isHidden = true
            
        }
        
    }

}

extension HeaderTableView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return collectionData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return collectionData[section].imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionCell.className, for: indexPath) as! CustomCollectionCell
        
        guard let image = collectionData[indexPath.section].imageArray[indexPath.item] else {return cell}
        let resizedImage = resizeImage(image: image, targetSize: CGSize(width: 150, height: 75))
        cell.setupContent(image: resizedImage, index: String(indexPath.item))

        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.className, for: indexPath) as! HeaderCollectionReusableView
            
            header.setContent(title: collectionData[indexPath.section].titleHeader)
            
            return header
            
        case UICollectionView.elementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.className, for: indexPath) as! FooterCollectionReusableView
            
            footer.setContent(title: collectionData[indexPath.section].titleFooter)
            
            return footer
            
        default:
            
            return UICollectionReusableView()
        }
    
    }

}

extension HeaderTableView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(item: 0, section: section)
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderCollectionReusableView.className, for: indexPath) as! HeaderCollectionReusableView
        
        return header.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        let indexPath = IndexPath(item: 0, section: section)
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterCollectionReusableView.className, for: indexPath) as! FooterCollectionReusableView
        
        return footer.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
    
}

