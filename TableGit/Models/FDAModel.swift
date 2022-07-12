//
//  FDAModel.swift
//  TableGit
//
//  Created by MINERVA on 12/07/2022.
//

import Foundation

struct FDAModel: Codable {
    var meta: MetaModel
}

struct MetaModel: Codable {
    var disclaimer: String
    var terms: String
    var license: String
    var last_updated: String
}
