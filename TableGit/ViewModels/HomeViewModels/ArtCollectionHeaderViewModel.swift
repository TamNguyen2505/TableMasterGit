//
//  ArtCollectionHeaderViewModel.swift
//  TableGit
//
//  Created by MINERVA on 09/08/2022.
//

import Foundation

struct ArtCollectionHeaderViewModel {
    //MARK: Properties
    private var model: TotalExhibitionModel
    
    //MARK: Init
    init(model: TotalExhibitionModel) {
        
        self.model = model
        
    }
    
    //MARK: Expected values
    var totalOfPictures: String {
        
        if let total = model.totalrecords {
            
            return String(total) + " pictures"
            
        } else {
            
            return "no picture"
            
        }
        
    }
    
}
