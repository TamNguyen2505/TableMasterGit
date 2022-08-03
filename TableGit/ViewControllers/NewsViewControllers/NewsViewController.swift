//
//  NewsViewController.swift
//  TableGit
//
//  Created by MINERVA on 03/08/2022.
//

import UIKit

class NewsViewController: BaseViewController {
    //MARK: Properties
    private let topScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    private lazy var newsTableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableCell.self, forCellReuseIdentifier: NewsTableCell.className)
        table.delegate = self
        table.dataSource = self
        table.prefetchDataSource = self
        table.estimatedRowHeight = UITableView.automaticDimension
        table.separatorStyle = .none
        return table
    }()
    
    let viewModel = NewsViewModel()
    var exhibitionData = [ExhibitionModel]() {
        didSet {
            self.newsTableView.reloadData()
        }
    }
    
    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath: DataLoadOperation]()
    
    //MARK: View cycles
    override func setupUI() {
        super.setupUI()
        
        Loader.shared.show()
        
        view.addSubview(topScrollView)
        topScrollView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
            
        }
        
        setupUIForTopTab()
        
        view.addSubview(newsTableView)
        newsTableView.snp.makeConstraints{ make in
            
            make.top.equalTo(topScrollView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
        
    }
    
    override func setupVM() {
        super.setupVM()
        
        Task {
            
            self.exhibitionData = await viewModel.getObjectAccordingToPage(page: 1)
            Loader.shared.hide()

        }
        
    }
    
    //MARK: Helpers
    private func setupUIForTopTab() {
        
        var labels = [UILabel]()
        
        for index in 1...10 {
            
            let label = UILabel()
            label.textColor = .darkGray
            label.font = UIFont.boldSystemFont(ofSize: 14)
            label.text = "Object \(index)"
            labels.append(label)
            
        }
        
        let hStack = UIStackView(arrangedSubviews: labels)
        hStack.spacing = 30
        hStack.axis = .horizontal
        
        topScrollView.addSubview(hStack)
        hStack.snp.makeConstraints{ make in
            
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            
        }
        
    }
    
    
}

//MARK: Table view data sources
extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return exhibitionData.count
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return exhibitionData[section].records?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableCell.className, for: indexPath) as! NewsTableCell
        
        guard let record = exhibitionData[indexPath.section].records?[indexPath.row] else {return cell}
        let data = NewsTableCellModel(exhibitionModelAray: record)
        
        cell.updateContent(data: data)
        
        return cell
        
    }
    
    
}

//MARK: Table willDisplay and endDisplay
extension NewsViewController {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! NewsTableCell
        
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let dataLoader = loadingOperations[indexPath] else {return}
        
        dataLoader.cancel()
        loadingOperations.removeValue(forKey: indexPath)
        
    }
    
}


//MARK: UITableViewDataSourcePrefetching
extension NewsViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if let _ = loadingOperations[indexPath] { return }
            guard let dataLoader = loadImage(at: indexPath) else {return}
            
            loadingQueue.addOperation(dataLoader)
            loadingOperations[indexPath] = dataLoader
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            guard let dataLoader = loadingOperations[indexPath] else {return}
            
            dataLoader.cancel()
            loadingOperations.removeValue(forKey: indexPath)
            
        }
        
    }
    
    func loadImage(at index: IndexPath) -> DataLoadOperation? {
        
        guard let record = exhibitionData[index.section].records?[index.row], let url = NewsTableCellModel(exhibitionModelAray: record).imageUrl else {return nil}
        
        return DataLoadOperation(url: url)
        
    }
    
}
