//
//  DetailedNewsViewModel.swift
//  TableGit
//
//  Created by MINERVA on 04/08/2022.
//

import UIKit
import Combine

//MARK: API
class DetailedNewsViewModel {
    //MARK: Properties
    private let networkManager = NetworkManager()
    var detailedInformationOfObject = DetailedNewsModel()
    var cancellable: AnyCancellable?
    @Published var percent = 0.0
    
    //MARK: Features
    func getDetailedInformationOfObject(objectID: String) async {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI]
        
        do {
            
            self.detailedInformationOfObject = try await networkManager.callAndParseAPI(accordingTo: .getDetailedInformationOfObject(path: objectID, parameters: parameters), parseInto: DetailedNewsModel.self) ?? DetailedNewsModel()
            
        } catch {
            
            
        }
        
    }
    
    func streamDownloadImage(imageID: String) async throws -> UIImage? {
        
        cancellable = networkManager.$byte.sink{ [weak self] (byte) in
            guard let self = self else {return}
            
            let startTime = CFAbsoluteTimeGetCurrent()
            self.percent = startTime
            
        }
        
        do {
                        
            let baseURL = imageID + URLs.OBJECT_FULL_IMAGE
            
            guard let data = try await networkManager.streamDownloadData(accordingTo: .downloadFullImageObject(baseURL: baseURL)) else {return nil}
                         
            cancellable?.cancel()
            
            return UIImage(data: data)
            
        } catch {
            
            throw error
            
        }
        
        
    }
    
    
}

