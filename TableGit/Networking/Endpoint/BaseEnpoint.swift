//
//  BaseEnpoint.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

enum BaseEnpoint {
    
    case getFDAInformation
    
}

extension BaseEnpoint: EndPointType {
    
    var baseURL: URL {
        
        switch self {
            
        case .getFDAInformation:
            return URL(string: "https://api.fda.gov/drug/label.json")!
        }
        
    }
    
    var path: String {
        
        switch self {
            
        case .getFDAInformation:
            return ""
        }
        
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
            
        case .getFDAInformation:
            return .get
        }
    }
    
    var task: HTTPTask {
        
        switch self {
            
        case .getFDAInformation:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlAndJsonEncoding, urlParameters: nil)
        }
        
    }
    
    var headers: HTTPHeaders {
        
        switch self {
            
        case .getFDAInformation:
            return [:]
        }
        
    }
    
    
}
