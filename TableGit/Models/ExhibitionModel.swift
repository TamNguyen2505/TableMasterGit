//
//  ExhibitionModel.swift
//  TableGit
//
//  Created by MINERVA on 25/07/2022.
//

import Foundation

struct ExhibitionModel: Codable {
    
    var info: TotalExhibitionModel?
    var records: [ExhibitionModelArray]?
    
}

struct TotalExhibitionModel: Codable {

    var totalrecordsperquery: Int?
    var totalrecords: Int?
    var pages: Int?
    var page: Int?
    
}

struct ExhibitionModelArray: Codable {
    
    var id: Int?
    var period: String?
    var images: [ExhibitionImage]?
    var description: String?
    var title: String?
    
}

struct ExhibitionImage: Codable {
    
    var copyright: String?
    var idsid: Int?
    var iiifbaseuri: String?
    
}


