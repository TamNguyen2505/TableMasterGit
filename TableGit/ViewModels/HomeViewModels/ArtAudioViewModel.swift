//
//  ArtAudioViewModel.swift
//  TableGit
//
//  Created by MINERVA on 08/08/2022.
//

import UIKit

class ArtAudioViewModel {
    //MARK: Properties
    private let networkManager = NetworkManager()
    private let artCollectionCellViewModel: ArtCollectionCellViewModel
    private var audioData: Audio?
    
    //MARK: Init
    init(artCollectionCellViewModel: ArtCollectionCellViewModel) {
        
        self.artCollectionCellViewModel = artCollectionCellViewModel
        
    }
    
    //MARK: Features
    var titleOfImage: String {
        
        return artCollectionCellViewModel.titleImage
        
    }
    
    var descriptionOfImage: String {
        
        return artCollectionCellViewModel.description ?? ""
        
    }
    
    var idOfImage: Int {
        
        return artCollectionCellViewModel.objectID
        
    }
    
    func getAudioAPI() async throws {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI]
        
        do {
            
            self.audioData = try await networkManager.callAndParseAPI(accordingTo: .downloadAudioObject(path: String(idOfImage), parameters: parameters), parseInto: Audio.self)
            
        } catch {
            
            
        }
        
        
    }
    
}
