//
//  PublicFunction.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 22/06/2022.
//

import UIKit

func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage? {
    let size = image.size
    
    let widthRatio  = targetSize.width  / size.width
    let heightRatio = targetSize.height / size.height
    
    // Figure out what our orientation is, and use that to form the rectangle
    var newSize: CGSize
    newSize = CGSize(width: size.width * widthRatio, height: size.height * heightRatio)
    
    // This is the rect that we've calculated out and this is what is actually used below
    let rect = CGRect(origin: .zero, size: newSize)
    
    // Actually do the resizing to the rect using the ImageContext stuff
    UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
    image.draw(in: rect)
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return newImage
}

func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
    
    guard let url = URL(string: url) else {return}
    
    let session = URLSession.shared
    let downloadTask = session.downloadTask(
        with: url, completionHandler: { url, response, error in
        
        if error == nil, let url = url,
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            completion(image)
            
        }
            
    })
    
    downloadTask.resume()
}

