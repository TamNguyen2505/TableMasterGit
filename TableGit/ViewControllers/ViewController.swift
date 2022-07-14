//
//  ViewController.swift
//  TableGit
//
//  Created by MINERVA on 22/06/2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
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
    
    private let searchViewModel = SearchViewModel()
    private var searchResults = [SearchResult]()
    private lazy var loadingQueue = OperationQueue()
    private lazy var loadingOperations = [IndexPath: DataLoadOperation]()

    let vm = ArtViewModel()
    var data = ArtModel() {
        didSet {
            self.infoTableView.reloadData()
        }
    }
    
    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setupVM()
        
    }
    
    //MARK: Helpers
    private func setupUI() {
        
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
    
    private func setupVM() {
        
        self.searchViewModel.didReceiveSearchResult = { [weak self] (success) in
            guard success, let self = self else {return}
            
            //self.infoTableView.reloadData()
            
        }
        
        Task {
            
            try await ITunesViewModel().fetchAPI(searchText: "Hello", category: .music)
//            try await vm.fetchAPI()
//            self.data = vm.artData ?? ArtModel()
        }

        
    }


}

//MARK: Table cell
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch searchViewModel.state {
        case .results(let list):
            
            return list.count
        
        default:
            
            return vm.artData?.data?.count ?? 1
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.className, for: indexPath) as! CustomCell
        cell.delegate = self
        
        switch searchViewModel.state {
        case .results(let list):
            
            let searchResult = list[indexPath.row]
            cell.setupContent(name: searchResult.name, message: searchResult.artist)
            
            break
        
        default:
            
            let info = vm.artData?.data?[indexPath.row]
            cell.setupContent(name: info?.artist_display ?? "", message: info?.place_of_origin ?? "")
            break
            
        }
    
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
extension ViewController {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderTableView.className) as! HeaderTableView
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
}

//MARK: Footer Table View
extension ViewController {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterTableView.className) as! FooterTableView
        
        view.delegate = self
        
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
}

extension ViewController: FooterTableViewDelegate {
    
    func didTapCancelButton(from view: FooterTableView) {
        
        let targetVC = CircleGraphViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
    }
    
    func didTapContinueButton(from view: FooterTableView) {
        
        let targetVC = WebViewController()
        self.navigationController?.pushViewController(targetVC, animated: true)
        
    }
    
}

extension ViewController: UITableViewDataSourcePrefetching {
    
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
//        guard case .results(let list) = searchViewModel.state else {return .none}
//        let searchResult = list[index]
        guard let data = vm.artData?.data?[index] else {return nil}
        
        return DataLoadOperation(artResults: data)
    }
    
}

extension ViewController: CustomCelllDelegate {
    
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

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        guard let text = textField.text else {return false}
        
        searchViewModel.performSearch(for: text)

        return true
        
    }
    
}


