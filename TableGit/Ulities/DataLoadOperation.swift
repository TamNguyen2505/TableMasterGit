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
 //   private let searchResult: SearchResult
    private let artResults: DataResponse
    
    //MARK: Init
    init(artResults: DataResponse) {
        
        self.artResults = artResults
      //  self.searchResult = searchResult
        
    }
    
    override func main() {
        super.main()
        if isCancelled {return}
        
//        let url = searchResult.imageLarge
        guard let id = artResults.image_id else {return}
        
        let url = "https://www.artic.edu/iiif/2/\(id)/full/843,/0/default.jpg"
        downloadImage(url: url){ (image) in
            
            DispatchQueue.main.async {[weak self] in
                guard let self = self, !self.isCancelled else { return }
                
                self.image = image
                self.loadingCompleteHandler?(self.image)
                
            }
            
        }
        
    }
    
    
}
