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
    case getDog(parameters: Parameters, header: HTTPHeaders)
    case uploadDog(parameters: Parameters, header: HTTPHeaders, media: Media)
    case downloadDog(url: String)
    case downloadArt(url: String)

}

extension BaseEnpoint: EndPointType {
    
    var baseURL: URL {
        
        switch self {
            
        case .getFDAInformation:
            return URLs.FDAUrl
            
        case .getArtInformation:
            return URLs.artUrl
            
        case .getITunesInformation:
            return URLs.ITunesUrl
            
        case .getDog:
            return URLs.dogUrl
            
        case .uploadDog:
            return URLs.dogUrl
            
        case .downloadDog(url: let url):
            return URL(string: url)!
            
        case .downloadArt(url: let url):
            return URL(string: url)!
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
            
        case .getDog:
            return "/v1/images/search"
            
        case .uploadDog:
            return "/v1/images/upload"
            
        case .downloadDog:
            return nil
            
        case .downloadArt:
            return nil
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
            
        case .getDog:
            return .get
            
        case .uploadDog:
            return .post
            
        case .downloadDog:
            return .get
            
        case .downloadArt:
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
            
        case .getDog(parameters: let parameters, header: let header):
            return .requestParametersAndHeaders(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: parameters, additionHeaders: header)
            
        case .uploadDog(parameters: let parameters, header: let header, media: let media):
            return .uploadFile(bodyParameters: parameters, bodyEncoding: .jsonEncodingWithMultipartdata, additionHeaders: header, media: media)
            
        case .downloadDog:
            return .request
            
        case .downloadArt:
            return .request
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
            
        case .getDog:
            return [:]
            
        case .uploadDog:
            return [:]
            
        case .downloadDog:
            return [:]
            
        case .downloadArt:
            return [:]
        }
        
    }
    
    
}
