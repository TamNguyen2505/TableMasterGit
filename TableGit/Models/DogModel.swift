//
//  DogModel.swift
//  TableGit
//
//  Created by MINERVA on 18/07/2022.
//

import Foundation

struct DogModel: Codable {
    
    var breeds: [Breeds]?
    var id: String?
    var url: String?
    var width: Int?
    var height: Int?
    
}

struct Breeds: Codable {
    
    var weight: WeightAndHeight?
    var height: WeightAndHeight?
    var id: Int?
    var name: String?
    var bred_for: String?
    var breed_group: String?
    var life_span: String?
    var temperament: String?
    var reference_image_id: String?
    
}

struct WeightAndHeight: Codable {
    
    var imperial: String?
    var metric: String?
    
}

struct UploadDod: Codable {
    
    var id: String?
    var url: String?
    var original_filename: String?
    var pending: Int?
    var approved: Int?
    
}
