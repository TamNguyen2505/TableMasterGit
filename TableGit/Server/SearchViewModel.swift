//
//  SearchViewModel.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 25/06/2022.
//

import UIKit

class SearchViewModel {
    //MARK: Typelias
    typealias SearchComplete = (Bool) -> Void
    
    //MARK: Properties
    var url: URL?
    private(set) var state: State = .notSearchedYet
    var didReceiveSearchResult: SearchComplete?
    
    //MARK: API fuctions
    func performSearch(for text: String, category: Category = .all) {
        
        Loader.shared.show()
        self.state = .loading
        let url = ITuneService.iTinesUrl(searchText: text, category: Category(rawValue: category.rawValue) ?? .all)
        self.url = url

        ITuneService.fetchSearchResults(url: url, completion: { (searchResults, error) in
            
            if let error = error as NSError?, error.code == -999 {
                
                self.state = .notSearchedYet
                DispatchQueue.main.async {
    
                    self.didReceiveSearchResult?(false)
                    
                }
                
            }
            
            if searchResults.isEmpty {
                
                self.state = .noResults
                
            } else {
                
                self.state = .results(searchResults)
                DispatchQueue.main.async {
       
                    self.didReceiveSearchResult?(true)
                    
                }
                
            }
            
            Loader.shared.hide()
            
        })
        
    }
    
}
