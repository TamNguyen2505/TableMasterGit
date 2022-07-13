//
//  NetworkError.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

public enum NetworkError : String, Error {
    
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
    
}
