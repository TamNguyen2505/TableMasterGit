//
//  DataLoadOperation.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 25/06/2022.
//

import UIKit

class DataLoadOperation: Operation {
    //MARK: Properties
    var image: UIImage?
    var loadingCompleteHandler: ((UIImage?) -> ())?
    private let searchResult: SearchResult
    
    //MARK: Init
    init(searchResult: SearchResult) {
        
        self.searchResult = searchResult
        
    }
    
    override func main() {
        super.main()
        if isCancelled {return}
        
        let url = searchResult.imageLarge
        downloadImage(url: url){ (image) in
            
            DispatchQueue.main.async {[weak self] in
                guard let self = self, !self.isCancelled else { return }
                
                self.image = image
                self.loadingCompleteHandler?(self.image)
                
            }
            
        }
        
    }
    
    
}
