//
//  FDAViewModel.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

class FDAViewModel {
    
    let router = Router<BaseEnpoint>()
    var results: FDAModel?
    
    func fetchAPI() {
        
        router.request(.getFDAInformation) { data, response, error in
            
            guard let data = data else {return}
            
            self.parse(data: data)
     
        }
        
    }
    
    private func parse(data: Data) {
        
        do {
            
            let result = try router.map(from: data, to: FDAModel.self)
            self.results = result
            
        } catch {
            
            print("DEBUG: JSON Parsing error \(error.localizedDescription)")
            
        }
        
    }
    
}
