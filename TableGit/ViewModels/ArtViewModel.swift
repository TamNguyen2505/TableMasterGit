//
//  ArtViewModel.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

class ArtViewModel {
    
    let router = Router<BaseEnpoint>()
    var artData: ArtModel? = nil
    
    func fetchAPI() {
        
        let paramters = ["page": 4, "limit": 100]
        
        router.request(.getArt(parameters: paramters)){ data,response,error in
            
            guard let data = data else {return}
            
            self.parse(data: data)
            
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
