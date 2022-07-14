//
//  JSONParameterEncoder.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoder {
    
    public static func encode(urlRequest: inout URLRequest, with parameters: Parameters?, and path: String?) throws {
        
        do {
            
            guard let parameters = parameters else {return}

            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            }
            
        } catch {
            
            throw NetworkError.encodingFailed
            
        }
        
    }
    
    
}
