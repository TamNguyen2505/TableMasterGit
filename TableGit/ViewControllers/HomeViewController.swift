//
//  ViewController.swift
//  TableGit
//
//  Created by MINERVA on 22/06/2022.
//

import UIKit

class HomeViewController: BaseViewController {
    //MARK: Properties
    private let titleNavigationLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to Art World"
        return label
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "default-avatar")?.resize(targetSize: .init(width: 40, height: 40))
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let artCollectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Art collection"
        return label
    }()
    
    private lazy var seeMoreButon: UIButton = {
        let button = UIButton()
        button.setTitle("See more", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        return button
    }()
    
    private lazy var artCollectionView: UICollectionView = {
        let layout = TopAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 20
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.showsVerticalScrollIndicator = false
        collection.showsHorizontalScrollIndicator = false
        collection.register(CustomCollectionCell.self, forCellWithReuseIdentifier: CustomCollectionCell.className)
        collection.delegate = self
        collection.dataSource = self
        collection.prefetchDataSource = self
        return collection
    }()

    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath: DataLoadOperation]()
    
    let vm = ArtViewModel()
    var data = ArtModel() {
        didSet {
            self.artCollectionView.reloadData()
        }
    }
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        Loader.shared.show()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleNavigationLabel)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: avatarImageView)
        
        view.addSubview(artCollectionTitleLabel)
        artCollectionTitleLabel.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.leading.equalToSuperview().offset(20)
            
        }
        
        view.addSubview(seeMoreButon)
        seeMoreButon.snp.makeConstraints{ make in
            
            make.centerY.equalTo(artCollectionTitleLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(20)
            make.leading.greaterThanOrEqualTo(artCollectionTitleLabel.snp.trailing)
            
        }
        
        view.addSubview(artCollectionView)
        artCollectionView.snp.makeConstraints{ make in
            
            make.top.equalTo(artCollectionTitleLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(400)
            
        }
        
    
    }
    
    override func setupVM() {
        super.setupVM()
        
        Task {
            
            try await vm.fetchAPI()
            self.data = vm.artData ?? ArtModel()
            Loader.shared.hide()
            
        }


    }
    
}

//MARK: Collection view data source
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return vm.artData?.data?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let cell = cell as! CustomCollectionCell
        
        let updateCellClosure: (UIImage?) -> () = { [unowned self] (image) in
            
            cell.setupImage(image: image)
            self.loadingOperations.removeValue(forKey: indexPath)
        }
        
        if let dataLoader = loadingOperations[indexPath] {
            
            if let image = dataLoader.image {
                
                cell.setupImage(image: image)
                loadingOperations.removeValue(forKey: indexPath)
                
            } else {
                
                dataLoader.loadingCompleteHandler = updateCellClosure
                
            }
            
        } else {
            
            if let dataLoader = loadImage(at: indexPath.row) {
                
                dataLoader.loadingCompleteHandler = updateCellClosure
                loadingQueue.addOperation(dataLoader)
                loadingOperations[indexPath] = dataLoader
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCollectionCell.className, for: indexPath) as! CustomCollectionCell
        let info = vm.artData?.data?[indexPath.row]
        
        cell.setupContent(titleImage: info?.title ?? "", artist: info?.artist_display ?? "")
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let dataLoader = loadingOperations[indexPath] else {return}
        
        dataLoader.cancel()
        loadingOperations.removeValue(forKey: indexPath)
        
    }
    
}

//MARK: Collection prefetch data
extension HomeViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if let _ = loadingOperations[indexPath] { return }
            guard let dataLoader = loadImage(at: indexPath.row) else {return}
            
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
    
    func loadImage(at index: Int) -> DataLoadOperation? {
        
        guard let id = vm.artData?.data?[index].image_id else {return nil}
        
        let url = "https://www.artic.edu/iiif/2/\(id)/full/843,/0/default.jpg"
        return DataLoadOperation(url: url)
    }
    
}
