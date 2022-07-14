//
//  BaseEnpoint.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

enum BaseEnpoint {
    
    case getFDAInformation
    case getArtInformation(parameters: Parameters)
    case getITunesInformation(parameters: Parameters)
    
}

extension BaseEnpoint: EndPointType {
    
    var baseURL: URL {
        
        switch self {
            
        case .getFDAInformation:
            return URLs.FDAUrl
            
        case .getArtInformation:
            return URLs.ITunesUrl
            
        case .getITunesInformation:
            return URLs.ITunesUrl
        }
        
    }
    
    var path: String? {
        
        switch self {
            
        case .getFDAInformation:
            return nil
            
        case .getArtInformation:
            return nil
            
        case .getITunesInformation:
            return "/search"
        }
        
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
            
        case .getFDAInformation:
            return .get
            
        case .getArtInformation:
            return .get
            
        case .getITunesInformation:
            return .get
        }
    }
    
    var task: HTTPTask {
        
        switch self {
            
        case .getFDAInformation:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlAndJsonEncoding, urlParameters: nil)
            
        case let .getArtInformation(parameters):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters)
            
        case .getITunesInformation(parameters: let parameters):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters)
        }
        
    }
    
    var headers: HTTPHeaders {
        
        switch self {
            
        case .getFDAInformation:
            return [:]
            
        case .getArtInformation:
            return [:]
            
        case .getITunesInformation:
            return [:]
        }
        
    }
    
    
}
