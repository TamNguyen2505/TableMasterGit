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
    var exhibitionData: ExhibitionModel? = nil
    
    
    //MARK: Features
    func getHardvardMuseumExhibition() async throws {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:0",
                                         "size": 200]

        self.exhibitionData = try await networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parameters), parseInto: ExhibitionModel.self)
        
    }
    
}
