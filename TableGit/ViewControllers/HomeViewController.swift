//
//  ViewController.swift
//  TableGit
//
//  Created by MINERVA on 22/06/2022.
//

import UIKit

class HomeViewController: BaseViewController {
    //MARK: Properties
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search here ..."
        textField.layer.cornerRadius = 5
        textField.layer.borderColor = UIColor.systemMint.cgColor
        textField.layer.borderWidth = 2
        textField.delegate = self
        return textField
    }()
    
    private lazy var infoTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.className)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.estimatedRowHeight = 167
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 61
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.register(HeaderTableView.self, forHeaderFooterViewReuseIdentifier: HeaderTableView.className)
        tableView.estimatedSectionFooterHeight = 90
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.register(FooterTableView.self, forHeaderFooterViewReuseIdentifier: FooterTableView.className)
        tableView.separatorStyle = .none
        return tableView
    }()
    
    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath: DataLoadOperation]()
    
    let vm = ArtViewModel()
    var data = ArtModel() {
        didSet {
            self.infoTableView.reloadData()
        }
    }
    
    //MARK: View cycle
    override func setupUI() {
        super.setupUI()
        
        Loader.shared.show()
        
        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
            
        }
        
        view.addSubview(infoTableView)
        infoTableView.snp.makeConstraints{ make in
            
            make.top.equalTo(searchTextField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            
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

//MARK: Table cell
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return vm.artData?.data?.count ?? 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.className, for: indexPath) as! CustomCell
        cell.delegate = self
        
        let info = vm.artData?.data?[indexPath.row]
        cell.setupContent(name: info?.artist_display ?? "", message: info?.place_of_origin ?? "")
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = cell as! CustomCell
        
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
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let dataLoader = loadingOperations[indexPath] else {return}
        
        dataLoader.cancel()
        loadingOperations.removeValue(forKey: indexPath)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
}

//MARK: Header Table View
extension HomeViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderTableView.className) as! HeaderTableView
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}

//MARK: Footer Table View
extension HomeViewController {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterTableView.className) as! FooterTableView
        
        view.delegate = self
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
}

extension HomeViewController: FooterTableViewDelegate {
    
    func didTapCancelButton(from view: FooterTableView) {
        
        let targetVC = CircleGraphViewController()
        self.navigationController?.pushViewController(targetVC, animated: false)
    }
    
    func didTapContinueButton(from view: FooterTableView) {
        
        let targetVC = WebViewController()
        self.navigationController?.pushViewController(targetVC, animated: false)
        
    }
    
}

extension HomeViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            
            if let _ = loadingOperations[indexPath] { return }
            guard let dataLoader = loadImage(at: indexPath.row) else {return}
            
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
    
    func loadImage(at index: Int) -> DataLoadOperation? {
        
        guard let id = vm.artData?.data?[index].image_id else {return nil}
        
        let url = "https://www.artic.edu/iiif/2/\(id)/full/843,/0/default.jpg"
        return DataLoadOperation(url: url)
    }
    
}

extension HomeViewController: CustomCelllDelegate {
    
    func deleteRow(from cell: CustomCell) {
        
        guard let indexEdit = infoTableView.indexPath(for: cell) else {return}
        
        imageArray.remove(at: indexEdit.row)
        
        infoTableView.beginUpdates()
        infoTableView.deleteRows(at: [indexEdit], with: .automatic)
        infoTableView.endUpdates()
        
    }
    
    func shouldResetUI(from cell: CustomCell) {
        
        guard let cells = infoTableView.visibleCells as? [CustomCell?], let indexEdit = infoTableView.indexPath(for: cell) else {return}
        
        cells.forEach{ [weak self] cell in
            
            guard let self = self, let unwrapCell = cell, let index = self.infoTableView.indexPath(for: unwrapCell), index != indexEdit else {return}
            
            cell?.resetUIForCardView()
            
        }
        
    }
    
}

extension HomeViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
        
    }
    
}


