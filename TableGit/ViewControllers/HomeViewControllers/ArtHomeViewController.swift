//
//  ArtHomeViewController.swift
//  TableGit
//
//  Created by MINERVA on 26/07/2022.
//

import UIKit

class ArtHomeViewController: BaseViewController {
    //MARK: Properties
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
                                                   heightDimension: .estimated(80))
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
    
    let viewModel = ArtHomeViewModel()
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

        headerType = .headerWidthRightSlideBarAndMiddleTitleAndLeftAvatar
        
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
extension ArtHomeViewController: UICollectionViewDataSource {
    
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
            
            guard let typedHeaderView = headerView as? ArtCollectionHeaderView, let info = exhibitionData[indexPath.section].info else { return headerView }
            let viewModel = ArtCollectionHeaderViewModel(model: info)
            
            typedHeaderView.updateContent(viewModel: viewModel)
            
            return typedHeaderView
            
        default:
            assert(false, "Invalid element type")
            
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return exhibitionData[section].records?.count ?? 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArtCollectionCell.className, for: indexPath) as? ArtCollectionCell, let info = exhibitionData[indexPath.section].records?[indexPath.item] else {return UICollectionViewCell()}
        let viewModel = ArtCollectionCellViewModel(model: info)
        
        cell.setupContent(viewmodel: viewModel)
        return cell
        
    }
    
}

//MARK: Collection delegate
extension ArtHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let targetVC = ArtAudioViewController()
        
        self.navigationController?.pushViewController(targetVC, animated: true)
        
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
        
        guard let info = exhibitionData[index.section].records?[index.item] else {return nil}
        let viewModel = ArtCollectionCellViewModel(model: info)
        guard let url = viewModel.imageUrl else {return nil}
        
        return DataLoadOperation(url: url)
        
    }
    
}




