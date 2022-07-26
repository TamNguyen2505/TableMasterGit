//
//  HardvardExhibitionViewModel.swift
//  TableGit
//
//  Created by MINERVA on 25/07/2022.
//

import Foundation

class HardvardExhibitionViewModel {
    //MARK: Properties
    let networkManager = NetworkManager()
    var exhibitionDataArray = [ExhibitionModel]()
    
    //MARK: Features
    func getHardvardMuseumExhibition() async throws {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:0",
                                         "size": 200]
        
        let parametersTwo: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:1",
                                         "size": 200]
        do {
            
            async let exhibitionData = try await networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parameters), parseInto: ExhibitionModel.self)
            
            let exhibitionDataUnAsync = try await exhibitionData
            
            self.exhibitionDataArray.append(exhibitionDataUnAsync ?? ExhibitionModel())
            
            async let exhibitionDataTwo = try await networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parametersTwo), parseInto: ExhibitionModel.self)
            
            let exhibitionDataTwoUnAsync = try await exhibitionDataTwo
            
            self.exhibitionDataArray.append(exhibitionDataTwoUnAsync ?? ExhibitionModel())
            
        } catch {
            
            throw error
            
        }

        
    }
    
    
}
