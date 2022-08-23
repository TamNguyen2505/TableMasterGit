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
    private let url: String
    
    //MARK: Init
    init(url: String) {
        
        self.url = url
        
    }
    
    override func main() {
        super.main()
        if isCancelled {return}
                
        downloadImage(url: url){ (image) in
            
            DispatchQueue.main.async {[weak self] in
                guard let self = self, !self.isCancelled else { return }
                
                self.image = image
                self.loadingCompleteHandler?(self.image)
                
            }
            
        }
        
    }
    
}

//        let url = "https://www.artic.edu/iiif/2/\(id)/full/843,/0/default.jpg"

