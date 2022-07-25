//
//  BaseEnpoint.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

enum BaseEnpoint {
    
    case getExihibitionFromHardvardMuseum(parameters: Parameters)

}

extension BaseEnpoint: EndPointType {
    
    var baseURL: URL {
        
        switch self {
            
        case .getExihibitionFromHardvardMuseum:
            return URLs.BASE_URL_MUSEUM!
        
        }
        
    }
    
    var path: String? {
        
        switch self {
        
        case .getExihibitionFromHardvardMuseum:
            return "/object"
        }
    
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
            
        case .getExihibitionFromHardvardMuseum:
            return .get
            
        }
    }
    
    var task: HTTPTask {
        
        switch self {
            
        case .getExihibitionFromHardvardMuseum(parameters: let parameters):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlAndJsonEncoding, urlParameters: parameters)
            
        }
        
    }
    
    var headers: HTTPHeaders {
        
        switch self {
    
        case .getExihibitionFromHardvardMuseum:
            return [:]
            
        }
        
    }
    
    
}
