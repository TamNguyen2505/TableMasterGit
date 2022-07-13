//
//  ArtViewModel.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

class ArtViewModel {
    
    let router = Router<BaseEnpoint>()
    let networkManager = NetworkManager()
    var didGetArtData: ((ArtModel) -> Void)?
    var artData: ArtModel? = nil
    
    func fetchAPI() async throws {
        
        let paramters = ["page": 2, "limit": 100]
        
        self.artData = try await networkManager.callAndParseAPI(accordingTo: .getArt(parameters: paramters), parseInto: ArtModel.self)
        
    }
    
}
