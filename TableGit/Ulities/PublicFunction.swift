//
//  PublicFunction.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit

func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
    
    guard let url = URL(string: url) else {return}
    
    let session = URLSession.shared
    let downloadTask = session.downloadTask(
        with: url) { url, response, error in
            
            if error == nil, let url = url,
               let data = try? Data(contentsOf: url),
               let image = UIImage(data: data) {
                completion(image)
                
            }
            
        }
    
    downloadTask.resume()
}

public func durationMeasurement(_ block: () -> ()) {
    let startTime = CFAbsoluteTimeGetCurrent()
    block()
    print(CFAbsoluteTimeGetCurrent() - startTime)
}
