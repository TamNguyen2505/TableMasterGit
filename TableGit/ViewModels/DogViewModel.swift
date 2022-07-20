//
//  DogViewModel.swift
//  TableGit
//
//  Created by MINERVA on 18/07/2022.
//

import Foundation
import UIKit

class DogViewModel {
    //MARK: Properties
    let networkManager = NetworkManager()
    var dogData: [DogModel]?
    var dogUpload: UploadDod?
    var image: UIImage?
    
    //MARK: Features
    func fetchAPI() async throws {
                
        let urlParameters: [String: Any] = ["size" : "med", "mime_types" : "jpg", "format": "json", "has_breeds": true, "order": "RANDOM", "page" : 0, "limit" : 100]
        
        let headers: [String: String] = ["x-api-key": "67edfac4-bf65-4cdd-a65f-a9c70993f5f5"]
                
        self.dogData = try await networkManager.callAndParseAPI(accordingTo: .getDog(parameters: urlParameters, header: headers), parseInto: [DogModel].self)
        
        
    
    }
    
    func uploadAndSearch() async throws {
        
        guard let url = self.dogData?.first?.url else {return}
        guard let data = try await networkManager.downloadData(accordingTo: .downloadDog(url: url)) else {return}
        guard let image = UIImage(data: data) else {return}
        
        let headers: [String: String] = ["x-api-key": "67edfac4-bf65-4cdd-a65f-a9c70993f5f5"]
        guard let media = Media(withImage: image, forKey: "file") else {return}
        
        self.dogUpload = try await networkManager.uploadFileAndParseResponse(accordingTo: .uploadDog(parameters: [:], header: headers, media: media), parseInto: UploadDod.self)

    }
    
}
