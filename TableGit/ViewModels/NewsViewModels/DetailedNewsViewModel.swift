//
//  DetailedNewsViewModel.swift
//  TableGit
//
//  Created by MINERVA on 04/08/2022.
//

import UIKit

//MARK: API
class DetailedNewsViewModel {
    //MARK: Properties
    private let networkManager = NetworkManager()
    var detailedInformationOfObject = DetailedNewsModel()

    //MARK: Features
    func getDetailedInformationOfObject(objectID: String) async {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI]
        
        do {
            
            self.detailedInformationOfObject = try await networkManager.callAndParseAPI(accordingTo: .getDetailedInformationOfObject(path: objectID, parameters: parameters), parseInto: DetailedNewsModel.self) ?? DetailedNewsModel()
            
        } catch {
            
            
        }
        
    }
    
    
}

