//
//  ParameterEncoding.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoder {
    
    static func encode(urlRequest: inout URLRequest, with parameters: Parameters?, and path: String?) throws
    
}

public enum ParameterEncoding {
    
    case urlEncoding
    case jsonEncoding
    case urlAndJsonEncoding
    
    public func encode(urlRequest: inout URLRequest,
                       bodyParameters: Parameters?,
                       urlParameters: Parameters?,
                       path: String?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder.encode(urlRequest: &urlRequest, with: urlParameters, and: path)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters, and: path)
                
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters,
                    let urlParameters = urlParameters else { return }
                try URLParameterEncoder.encode(urlRequest: &urlRequest, with: urlParameters, and: path)
                try JSONParameterEncoder.encode(urlRequest: &urlRequest, with: bodyParameters, and: path)
                
            }
        }catch {
            throw error
        }
    }
}
