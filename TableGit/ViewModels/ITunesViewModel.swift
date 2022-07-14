//
//  ITunesViewModel.swift
//  TableGit
//
//  Created by MINERVA on 14/07/2022.
//

import Foundation

class ITunesViewModel {
    //MARK: Properties
    let networkManager = NetworkManager()
    var iTunesData: ResultArray? = nil
    
    //MARK: Features
    func fetchAPI(searchText: String, category: Category) async throws {
        
        let kind: String
        switch category {
        case .music: kind = "musicTrack"
        case .software: kind = "software"
        case .ebooks: kind = "ebook"
        case .all: kind = ""
        }
        
        let locale = Locale.autoupdatingCurrent
        let language = locale.identifier
        let countryCode = locale.regionCode ?? "en_US"
        
        let encodedText = searchText.addingPercentEncoding(
            withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        
        let parameters: [String : Any] = ["term" : encodedText, "limit" : 800, "entity" : kind, "lang" : language, "country" : countryCode]
        
        self.iTunesData = try await networkManager.callAndParseAPI(accordingTo: .getITunesInformation(parameters: parameters), parseInto: ResultArray.self)
        
        
    }
    
}
