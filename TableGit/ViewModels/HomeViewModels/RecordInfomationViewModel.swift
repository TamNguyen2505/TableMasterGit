//
//  RecordInfomationViewModel.swift
//  TableGit
//
//  Created by MINERVA on 10/08/2022.
//

import Foundation
import UIKit

class RecordInfomationViewModel: NSObject {
    //MARK: Properties
    private let networkManager = NetworkManager()
    private var personalInfomationModel: HardvardMuseumPerson? {
        didSet {
            didGetAllHardvardPersonalInformation = true
        }
    }
    @objc dynamic var didGetAllHardvardPersonalInformation = false
    @objc dynamic var didGetImage: UIImage?

    //MARK: Features
    func getPersonalInformationModel(personID: Int) async throws {
        
        let personID = String(personID)
        let parameters: [String: Any] = ["apikey": URLs.keyAPI]
        
        do {
            
            self.personalInfomationModel = try await networkManager.callAndParseAPI(accordingTo: .getPeronalInformation(path: personID, parameters: parameters), parseInto: HardvardMuseumPerson.self)
            
        } catch {
            
        }
        
    }
    
    func getRecordImage(with url: URL) async {
        
        let urlString = url.absoluteString
        
        do {
            
            guard let data = try await networkManager.downloadData(accordingTo: .downloadFullImageObject(baseURL: urlString)) else {return}
            self.didGetImage = UIImage(data: data)
            
        } catch {
            
        }
        
    }
    
    
}

extension RecordInfomationViewModel {
    
    func createExhibitionURLOfPerson() -> URLRequest? {
        
        guard let urlString = self.personalInfomationModel?.url, let url = URL(string: urlString) else {return nil}
        let urlRequest = URLRequest(url: url)
        
        return urlRequest
        
    }
    
    
}
