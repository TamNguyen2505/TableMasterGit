//
//  ArtCollectionCellViewModel.swift
//  TableGit
//
//  Created by MINERVA on 09/08/2022.
//

import Foundation

struct ArtCollectionCellViewModel {
    //MARK: Properties
    private var model: ExhibitionModelArray
    
    //MARK: Init
    init(model: ExhibitionModelArray) {
        
        self.model = model
        
    }
    
    //MARK: Expected values
    var titleImage: String {
        
        return model.title ?? ""
        
    }
    
    var culture: String {
        
        return model.culture ?? ""
        
    }
    
    var imageUrl: URL? {
        
        guard let id = model.images?.first?.iiifbaseuri, let url = URL(string: id + "/full/full/0/default.jpg") else {return nil}
        return url
        
    }
    
    var description: String? {
        
        return model.description ?? ""
        
    }
    
    var objectID: Int {
        
        return model.objectid ?? 0
        
    }
    
}
