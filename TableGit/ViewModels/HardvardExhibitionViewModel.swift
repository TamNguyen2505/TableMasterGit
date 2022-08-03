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
      
    //MARK: Features
    func getHardvardMuseumExhibition() async -> [ExhibitionModel] {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:0",
                                         "size": 200]
        
        let parametersTwo: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:10",
                                         "size": 200]
        
        let parametersThree: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:20",
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
                
                group.addTask{
                    
                    do {
                        
                        return try await self.networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parametersTwo), parseInto: ExhibitionModel.self) ?? ExhibitionModel()
                        
                    } catch {
                        
                        return ExhibitionModel()
                        
                    }
                    
                }
                
                group.addTask{
                    
                    do {
                        
                        return try await self.networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parametersThree), parseInto: ExhibitionModel.self) ?? ExhibitionModel()
                        
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
