//
//  NetworkManager.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation
import UIKit

enum NetworkResponse:String {
    
    case success
    case authenticationError = "You need to be authenticated first."
    case badRequest = "Bad request"
    case outdated = "The url you requested is outdated."
    case failed = "Network request failed."
    case noData = "Response returned with no data to decode."
    case unableToDecode = "We could not decode the response."
    
}

enum Result<String>{
    
    case success
    case failure(String)
    
}

class NetworkManager {
    //MARK: Properties
    let router = Router<BaseEnpoint>()
    
    //MARK: Features
    public func callAndParseAPI<D: Codable>(accordingTo caseEndPoint: BaseEnpoint, parseInto model: D.Type) async throws -> D? {
        
        let routerResponse = try await router.request(caseEndPoint)
        
        guard let response = routerResponse.response as? HTTPURLResponse else {return nil}
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            guard let responseData = routerResponse.data, let decodedModel = try? await self.map(from: responseData, to: model) else {return nil}
            
            let information = NetworkLogger(urlRequest: routerResponse.urlRequest, data: routerResponse.data, httpURLResponse: response)
            information.announce()
                        
            return decodedModel
            
        case .failure(_):
            
            return nil
            
        }
        
    }
    
    public func uploadFileAndParseResponse<D: Codable>(accordingTo caseEndPoint: BaseEnpoint, parseInto model: D.Type) async throws -> D? {
        
        let routerResponse = try await router.upload(caseEndPoint)
        
        guard let response = routerResponse.response as? HTTPURLResponse else {return nil}
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            guard let responseData = routerResponse.data, let decodedModel = try? await self.map(from: responseData, to: model) else {return nil}
            
            let information = NetworkLogger(urlRequest: routerResponse.urlRequest, data: routerResponse.data, httpURLResponse: response)
            information.announce()
                        
            return decodedModel
                                    
        case .failure(_):
            
            return nil
            
        }
        
        
    }
    
    public func downloadData(accordingTo caseEndPoint: BaseEnpoint) async throws -> Data? {
        
        let routerResponse = try await router.download(caseEndPoint)
        
        guard let response = routerResponse.response as? HTTPURLResponse else {return nil}
        let result = handleNetworkResponse(response)
        
        switch result {
        case .success:
            guard let responseData = routerResponse.data else {return nil}
            
            let information = NetworkLogger(urlRequest: routerResponse.urlRequest, data: routerResponse.data, httpURLResponse: response)
            information.announce()
                        
            return responseData
                                    
        case .failure(_):
            
            return nil
            
        }
        
    }
        
    //MARK: Helpers
    public func map<D: Codable>(from data: Data, to type: D.Type, decoder: JSONDecoder = JSONDecoder()) async throws -> D {

        do {
            
            return try decoder.decode(type, from: data)
            
        } catch(_) {
            
            throw NetworkError.encodingFailed
            
        }
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> Result<String>{
        
        switch response.statusCode {
        case 200...299: return .success
        case 401...500: return .failure(NetworkResponse.authenticationError.rawValue)
        case 501...599: return .failure(NetworkResponse.badRequest.rawValue)
        case 600: return .failure(NetworkResponse.outdated.rawValue)
        default: return .failure(NetworkResponse.failed.rawValue)
            
        }
    }
    
}

