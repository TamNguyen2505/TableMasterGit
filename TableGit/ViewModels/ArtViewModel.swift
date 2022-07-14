//
//  ArtViewModel.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

class ArtViewModel {
    //MARK: Properties
    let networkManager = NetworkManager()
    var artData: ArtModel? = nil
    
    //MARK: Features
    func fetchAPI() async throws {
        
        let paramters = ["page": 10, "limit": 100]
        
        self.artData = try await networkManager.callAndParseAPI(accordingTo: .getArtInformation(parameters: paramters), parseInto: ArtModel.self)
        
    }
    
}
