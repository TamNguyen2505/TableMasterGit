//
//  ArtModel.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

struct ArtModel: Codable {
    var pagination: Pagination?
    var data: [DataResponse]?
}

struct Pagination: Codable {
    
}

struct DataResponse: Codable {
    var id: Int?
    var title: String?
    var thumbnail: Thumbnail?
    var artist_display: String?
    var place_of_origin: String?
    var image_id: String?
    var timestamp: String?
}

struct Thumbnail: Codable {
    var alt_text: String?
}
