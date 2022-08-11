//
//  HomeViewModel.swift
//  TableGit
//
//  Created by MINERVA on 09/08/2022.
//

import Foundation
import UIKit

class HomeViewModel: NSObject {
    //MARK: Properties
    private let networkManager = NetworkManager()
    private var hardvardMuseumObjectModel = [HardvardMuseumObject?]() {
        didSet {
            didGetAllHardvardMuseumObjectModel = true
        }
    }
    @objc dynamic var didGetAllHardvardMuseumObjectModel = false
    
    //MARK: Features
    func getHardvardMuseumObjectModel() async {
        
        let parameters: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:0",
                                         "size": 200]
        
        let parametersTwo: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:10",
                                         "size": 200]
        
        let parametersThree: [String: Any] = ["apikey": URLs.keyAPI,
                                         "q": "totalpageviews:20",
                                         "size": 200]
        
        self.hardvardMuseumObjectModel = await withTaskGroup(of: HardvardMuseumObject?.self, returning: [HardvardMuseumObject?].self) { group in
            
            group.addTask{
                
                do {
                    
                    return try await self.networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parameters), parseInto: HardvardMuseumObject.self)
                    
                } catch {
                    
                    return nil
                    
                }
                
            }
            
            group.addTask{
                
                do {
                    
                    return try await self.networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parametersTwo), parseInto: HardvardMuseumObject.self)
                    
                } catch {
                    
                    return nil
                    
                }
                
            }
            
            group.addTask{
                
                do {
                    
                    return try await self.networkManager.callAndParseAPI(accordingTo: .getExihibitionFromHardvardMuseum(parameters: parametersThree), parseInto: HardvardMuseumObject.self)
                    
                } catch {
                    
                    return nil
                    
                }
                
            }

            var collection = [HardvardMuseumObject]()
            
            for await result in group {
                guard let result = result else {continue}
                
                collection.append(result)
                
            }
            
            return collection
            
        }
        
        
    }
    
}

extension HomeViewModel {
    
    func numberOfSections() -> Int {
        
        return self.hardvardMuseumObjectModel.count
        
    }
    
    func createHomeHeaderCollectionViewModel(atIndexPath: IndexPath) -> HomeHeaderCollectionViewModel? {
        
        guard let model = self.hardvardMuseumObjectModel[atIndexPath.section]?.info else {return nil}
        
        return HomeHeaderCollectionViewModel(model: model)
        
    }
    
    func numberOfItemsInSection(section: Int) -> Int {
        
        return self.hardvardMuseumObjectModel[section]?.records?.count ?? 1
        
    }
    
    func createHardvardMuseumObjectRecord(atIndexPath: IndexPath) -> HomeCollectionCellViewModel? {
        
        guard let model = self.hardvardMuseumObjectModel[atIndexPath.section]?.records?[atIndexPath.item] else {return nil}
        
        return HomeCollectionCellViewModel(model: model)
        
    }
    
}

extension HomeViewModel {
    
    func createPersonID(atIndexPath: IndexPath) -> Int? {
        
        guard let id = self.hardvardMuseumObjectModel[atIndexPath.section]?.records?[atIndexPath.item].people?.first?.personid else {return nil}
        
        return id
        
    }
    
}
