//
//  NewsViewModel.swift
//  TableGit
//
//  Created by MINERVA on 03/08/2022.
//

import UIKit

//MARK: API
class NewsViewModel {
    //MARK: Properties
    private let networkManager = NetworkManager()
    
    //MARK: Features
    func getObjectAccordingToPage(page: Int) async -> [ExhibitionModel] {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:\(page)",
                                         "size": 200]

        return await Task { () -> [ExhibitionModel] in
            
            await withTaskGroup(of: ExhibitionModel.self, returning: [ExhibitionModel].self) {
                [unowned self] group in
                
                group.addTask{
                    
                    do {
                        
                        return try await self.networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parameters), parseInto: ExhibitionModel.self) ?? ExhibitionModel()
                        
                    } catch {
                        
                        return ExhibitionModel()
                        
                    }
                    
                }
                
                var collection = [ExhibitionModel]()
                
                for await result in group {
                    
                    collection.append(result)
                    
                }
                
                return collection
                
            }
            
            
        }.value
        
    }
    
}

//MARK: Resolved API
struct NewsTableCellModel {
    //MARK: Properties
    private var exhibitionModelArray: ExhibitionModelArray
    
    //MARK: Init
    init(exhibitionModelAray: ExhibitionModelArray) {
        
        self.exhibitionModelArray = exhibitionModelAray
        
    }
    
    //MARK: Expected output
    var imageUrl: URL? {
        
        guard let id = exhibitionModelArray.images?.first?.iiifbaseuri, let url = URL(string: id + "/full/full/0/default.jpg") else {return nil}
        return url
        
    }
    
    var titleImage: String {
        
        return exhibitionModelArray.title ?? ""
        
    }
    
    var widthValue: String {
        
        if let width = exhibitionModelArray.images?.first?.width {
            
            return String(width)
            
        } else {
            
            return "None"
            
        }
        
    }
    
    var heightValue: String {
        
        if let height = exhibitionModelArray.images?.first?.height {
            
            return String(height)
            
        } else {
            
            return "None"
            
        }
    }
    
    var dateValue: String {
        
        return exhibitionModelArray.images?.first?.date?.formatDateToString(format: DateFormatterType.DDMMYYYY) ?? "None"
        
    }
    
    
}
