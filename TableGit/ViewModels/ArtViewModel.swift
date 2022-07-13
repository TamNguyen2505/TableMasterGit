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
    var artData: ArtModel? = nil
    
    func fetchAPI() {
        
        let paramters = ["page": 3, "limit": 100]
        
        networkManager.callAndParseAPI(accordingTo: .getArt(parameters: paramters), parseInto: ArtModel.self) { [weak self] model in
            
            self?.artData = model
            
        }
        
    }
    
    private func parse(data: Data) {
        
        do {
            
            let result = try JSONDecoder().decode(ArtModel.self, from: data)
            self.artData = result
            
        } catch {
            
            print("DEBUG: JSON Parsing error \(error.localizedDescription)")
            
        }
        
        
    }

    
    
}
