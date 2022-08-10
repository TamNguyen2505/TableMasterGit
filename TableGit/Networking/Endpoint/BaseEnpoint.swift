//
//  BaseEnpoint.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

enum BaseEnpoint {
    
    case getExihibitionFromHardvardMuseum(parameters: Parameters)
    case getDetailedInformationOfObject(path: String, parameters: Parameters)
    case downloadFullImageObject(baseURL: String)
    case downloadAudioObject(path: String, parameters: Parameters)
    case getPeronalInformation(path: String, parameters: Parameters)
    
}

extension BaseEnpoint: EndPointType {
    
    var baseURL: URL {
        
        switch self {
            
        case .getExihibitionFromHardvardMuseum:
            return URLs.BASE_URL_MUSEUM!
        
        case .getDetailedInformationOfObject:
            return URLs.BASE_URL_MUSEUM!
            
        case .downloadFullImageObject(baseURL: let baseURL):
            return URL(string: baseURL)!
            
        case .downloadAudioObject:
            return URLs.BASE_URL_MUSEUM!
            
        case .getPeronalInformation:
            return URLs.BASE_URL_MUSEUM!
        }
        
    }
    
    var path: String? {
        
        switch self {
        
        case .getExihibitionFromHardvardMuseum:
            return URLs.OBJECT_PATH_MUSEUM
            
        case .getDetailedInformationOfObject(path: let path, parameters: _):
            return URLs.OBJECT_PATH_MUSEUM + "/\(path)"
            
        case .downloadFullImageObject:
            return nil
            
        case .downloadAudioObject(path: let path, parameters: _):
            return URLs.AUDIO_PATH_MUSEUM + "/\(path)"
            
        case .getPeronalInformation(path: let path, parameters: _):
            return URLs.PERSON_PATH_MUSEUM + "/\(path)"
        }
    
    }
    
    var httpMethod: HTTPMethod {
        
        switch self {
            
        case .getExihibitionFromHardvardMuseum:
            return .get
            
        case .getDetailedInformationOfObject:
            return .get
            
        case .downloadFullImageObject:
            return .get
            
        case .downloadAudioObject:
            return .get
            
        case .getPeronalInformation:
            return .get
        }
    }
    
    var task: HTTPTask {
        
        switch self {
            
        case .getExihibitionFromHardvardMuseum(parameters: let parameters):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlAndJsonEncoding, urlParameters: parameters)
            
        case .getDetailedInformationOfObject(path: _, parameters: let parameters):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters)
            
        case .downloadFullImageObject:
            return .downloadFile
            
        case .downloadAudioObject(path: _, parameters: let parameters):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters)
            
        case .getPeronalInformation(path: _, parameters: let parameters):
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters)
        }
        
    }
    
    var headers: HTTPHeaders {
        
        switch self {
    
        case .getExihibitionFromHardvardMuseum:
            return [:]
            
        case .getDetailedInformationOfObject:
            return [:]
            
        case .downloadFullImageObject:
            return [:]
            
        case .downloadAudioObject:
            return [:]
            
        case .getPeronalInformation:
            return [:]
        }
        
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        
        return .useProtocolCachePolicy
        
    }
    
}
