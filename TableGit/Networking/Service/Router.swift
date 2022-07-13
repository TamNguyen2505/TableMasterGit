//
//  Router.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation
import UIKit

public typealias NetworkRouterCompletion = (_ urlRequest: URLRequest?, _ data: Data?, _ response: URLResponse?, _ error: Error?)->()

protocol NetworkRouter: AnyObject {
    associatedtype EndPoint: EndPointType
    func request(_ route: EndPoint) async throws -> (urlRequest: URLRequest?, data: Data?, response: URLResponse?, error: Error?)
    func cancel()
}

class Router<EndPoint: EndPointType>: NetworkRouter {

    private var task: URLSessionTask?
    
    func request(_ route: EndPoint) async throws -> (urlRequest: URLRequest?, data: Data?, response: URLResponse?, error: Error?) {
        let session = URLSession.shared
        let request = try self.buildRequest(from: route)
        
        task = session.dataTask(with: request)
        let (data, response) = try await session.data(for: request)
 
        self.task?.resume()
        
        return (request, data, response, task?.error)
    }
    
    func cancel() {
        
        self.task?.cancel()
        
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        
        var request = URLRequest(url: route.baseURL)
        
        request.httpMethod = route.httpMethod.rawValue
        
        do {
            switch route.task {
            case .request:
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            case .requestParametersAndHeaders(let bodyParameters,
                                              let bodyEncoding,
                                              let urlParameters,
                                              let additionalHeaders):
                
                self.addAdditionalHeaders(additionalHeaders, request: &request)
                try self.configureParameters(bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
                
            }
            return request
            
        } catch {
            
            throw error
            
        }
        
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?,
                                         bodyEncoding: ParameterEncoding,
                                         urlParameters: Parameters?,
                                         request: inout URLRequest) throws {
        do {
            
            try bodyEncoding.encode(urlRequest: &request, bodyParameters: bodyParameters, urlParameters: urlParameters)
            
        } catch {
            
            throw error
            
        }
        
    }
    
    fileprivate func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?, request: inout URLRequest) {
        
        guard let headers = additionalHeaders else { return }
        
        for (key, value) in headers {
            
            request.setValue(value, forHTTPHeaderField: key)
            
        }
        
    }
    
}

