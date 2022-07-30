//
//  ArtHomeViewController.swift
//  TableGit
//
//  Created by MINERVA on 26/07/2022.
//

import UIKit

class ArtHomeViewController: BaseViewController {
    //MARK: Properties
    private lazy var sideBarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "icons8-menu")?.resize(targetSize: .init(width: 40, height: 40))
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEventFromSideBar))
        iv.addGestureRecognizer(tap)
        
        return iv
    }()
    
    private let titleNavigationLabel: UILabel = {
        let label = UILabel()
        
        let attributesLineOne: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        let lineOne = NSMutableAttributedString(string: "Welcome to\n", attributes: attributesLineOne)
        
        let attributesLineTwo: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 18),
                                                                .foregroundColor: UIColor.systemRed]
        let lineTwo = NSMutableAttributedString(string: "Art World", attributes: attributesLineTwo)
        
        let totalString: NSMutableAttributedString = lineOne
        totalString.append(lineTwo)
        
        label.attributedText = totalString
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "default-avatar")?.resize(targetSize: .init(width: 40, height: 40))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var artLayOut: UICollectionViewLayout = {
        let sectionProvider = { [weak self] (sectionIndex: Int,
                                 layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            guard let self = self else {return nil}

            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(350))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(350))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: itemSize, subitem: item, count: 1)
            let fractionWidth = 300.0
            let sideInset = ((self.view.frame.width - fractionWidth) / 2)
        
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: sideInset, bottom: 0, trailing: sideInset)
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuousGroupLeadingBoundary
            section.visibleItemsInvalidationHandler = self.observeGroup
            
            let titleSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(44))
            let titleSupplementary = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: titleSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            section.boundarySupplementaryItems = [titleSupplementary]
            return section
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        
        let layout = UICollectionViewCompositionalLayout(
            sectionProvider: sectionProvider, configuration: config)
        return layout
    }()
    
    private lazy var artCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: artLayOut)
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ArtCollectionCell.self, forCellWithReuseIdentifier: ArtCollectionCell.className)
        collectionView.register(ArtCollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ArtCollectionHeaderView.className)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 90, right: 0)
        return collectionView
    }()
    
    private var centerCell: ArtCollectionCell?
    private var observeGroup: NSCollectionLayoutSectionVisibleItemsInvalidationHandler?

    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath: DataLoadOperation]()
    
    let viewModel = HardvardExhibitionViewModel()
    var exhibitionData = [ExhibitionModel]() {
        didSet {
            self.artCollectionView.reloadData()
        }
    }
    
    private lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    //MARK: Init
    override func setupUI() {
        super.setupUI()
        
        Loader.shared.show()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: sideBarImageView)
        self.navigationItem.titleView = titleNavigationLabel
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarImageView)
        
        view.addSubview(artCollectionView)
        artCollectionView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
            
        }
        
        observeGroup = { [weak self] (visibleItems, offset, _) in
            guard let self = self else {return}
            
            self.highlightCenterCell(visibleItems: visibleItems, offset: offset)
            
        }
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        Task {
            
            self.exhibitionData = await viewModel.getHardvardMuseumExhibition()
            Loader.shared.hide()

        }
        
    }
    
    //MARK: Actions
    @objc func handleEventFromSideBar() {
        
        let targetVC = SideBarViewController()
        
        slideInTransitioningDelegate.direction = .left
        targetVC.transitioningDelegate = slideInTransitioningDelegate
        targetVC.modalPresentationStyle = .custom
        
        self.present(targetVC, animated: true, completion: nil)
        
    }
    
    //MARK: Helpers
    private func highlightCenterCell(visibleItems: [NSCollectionLayoutVisibleItem], offset: CGPoint) {
        
        let centerXPoint = offset.x + self.artCollectionView.bounds.midX
        
        for item in visibleItems where abs(item.frame.midX - centerXPoint) < 80 {
            
            self.centerCell = (self.artCollectionView.cellForItem(at: item.indexPath)) as? ArtCollectionCell
            self.centerCell?.transformToLarge()
            
        }
                    
        if let centerCell = self.centerCell {
            
            let offset = abs(centerCell.center.x - centerXPoint)
            
            if offset > 20 {
                
                centerCell.transformToStandard()
                self.centerCell = nil
                
            }
            
        }
        
    }
        
}

//MARK: Collection view data source
extension ArtHomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return exhibitionData.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: ArtCollectionHeaderView.className,
                for: indexPath)
            
            guard let typedHeaderView = headerView as? ArtCollectionHeaderView, let info = exhibitionData[indexPath.section].info?.totalrecords else { return headerView }
            
            
            typedHeaderView.updateContent(title: "\(info) pictures")
            
            return typedHeaderView
            
        default:
            assert(false, "Invalid element type")
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return exhibitionData[section].records?.count ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtCollectionCell.className, for: indexPath) as! ArtCollectionCell
        let info = exhibitionData[indexPath.section].records?[indexPath.item]
        
        cell.setupContent(titleImage: info?.title ?? "", artist: info?.description ?? "")
        return cell
        
    }
    
}

//MARK: Collection willDisplay and endDisplay
extension ArtHomeViewController {
        
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
                
        let cell = cell as! ArtCollectionCell
        
        if let dataLoader = loadingOperations[indexPath] {
            
            if let image = dataLoader.image {
                
                cell.setupImage(image: image)
                loadingOperations.removeValue(forKey: indexPath)
                
            } else {
                
                dataLoader.completionBlock = {[unowned self] in
                    
                    cell.setupImage(image: dataLoader.image)
                    self.loadingOperations.removeValue(forKey: indexPath)

                }
                
            }
            
        } else {
            
            if let dataLoader = loadImage(at: indexPath) {
                
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
                dataLoader.completionBlock = {[unowned self] in
                    
                    cell.setupImage(image: dataLoader.image)
                    self.loadingOperations.removeValue(forKey: indexPath)
                    
                }
                
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let dataLoader = loadingOperations[indexPath] else {return}
        
        dataLoader.cancel()
        loadingOperations.removeValue(forKey: indexPath)
        
    }
    
}

//MARK: Collection prefetch data
extension ArtHomeViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if let _ = loadingOperations[indexPath] { return }
            guard let dataLoader = loadImage(at: indexPath) else {return}
            
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            guard let dataLoader = loadingOperations[indexPath] else {return}
            
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
            
        }
        
    }
    
    func loadImage(at index: IndexPath) -> DataLoadOperation? {
        
        guard let id = exhibitionData[index.section].records?[index.item].images?.first?.iiifbaseuri else {return nil}
        
        let url = id + "/full/full/0/default.jpg"
        
        return DataLoadOperation(url: url)
    }
    
}




