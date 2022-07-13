//
//  BaseEnpoint.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

enum BaseEnpoint {
    
    case getFDAInformation
    case getArt(parameters: Parameters)
    
}

extension BaseEnpoint: EndPointType {
    
    var baseURL: URL {
        
        switch self {
            
        case .getFDAInformation:
            return URL(string: "https://api.fda.gov/drug/label.json")!
        case .getArt:
            return URL(string: "https://api.artic.edu/api/v1/artworks")!
        }
        
    }
    
    var path: String {
        
        switch self {
            
        case .getFDAInformation:
            return ""
        case .getArt:
            return ""
        }
        
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
            
        case .getFDAInformation:
            return .get
        case .getArt:
            return .get
        }
    }
    
    var task: HTTPTask {
        
        switch self {
            
        case .getFDAInformation:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlAndJsonEncoding, urlParameters: nil)
        case let .getArt(parameters):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters)
        }
        
    }
    
    var headers: HTTPHeaders {
        
        switch self {
            
        case .getFDAInformation:
            return [:]
        case .getArt:
            return [:]
            
        }
        
    }
    
    
}
