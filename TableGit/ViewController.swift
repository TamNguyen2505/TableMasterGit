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
    private lazy var infoTableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.backgroundColor = .clear
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.className)
        tableView.delegate = self
        tableView.dataSource = self
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

    //MARK: View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    //MARK: Helpers
    private func setupUI() {
        
        view.addSubview(infoTableView)
        infoTableView.snp.makeConstraints{ make in
            
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            
        }
        
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderTableView.className) as! HeaderTableView
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return imageArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.className, for: indexPath) as! CustomCell
        cell.setupContent(image: imageArray[indexPath.row], name: "NGUYEN MINH TAM", message: "Hang out anytime, anywhere ... Messenger makes it easy and fun to stay close to your favorite people. ... New! Message your Instagram friends right from Messenger.")
        cell.delegate = self
    
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: FooterTableView.className) as! FooterTableView
        return view
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        return UITableView.automaticDimension
        
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


