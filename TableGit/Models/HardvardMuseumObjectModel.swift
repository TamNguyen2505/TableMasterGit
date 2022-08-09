//
//  HardvardMuseumObjectModel.swift
//  TableGit
//
//  Created by MINERVA on 09/08/2022.
//

import Foundation

// MARK: - HardvardMuseumObject
struct HardvardMuseumObject: Codable {
    let info: Info?
    let records: [Record]?
}

// MARK: - Info
struct Info: Codable {
    let totalrecordsperquery, totalrecords, pages, page: Int?
    let next: String?
}

// MARK: - Record
struct Record: Codable {
    let copyright: JSONNull?
    let contextualtextcount: Int?
    let creditline: String?
    let accesslevel: Int?
    let dateoflastpageview: JSONNull?
    let classificationid: Int?
    let division: String?
    let markscount, publicationcount, totaluniquepageviews: Int?
    let contact: String?
    let colorcount, rank: Int?
    let details: Details?
    let state: JSONNull?
    let id: Int?
    let verificationleveldescription, period: String?
    let images: [Image]?
    let worktypes: [Worktype]?
    let imagecount, totalpageviews, accessionyear: Int?
    let standardreferencenumber: String?
    let signed: JSONNull?
    let classification: String?
    let relatedcount, verificationlevel: Int?
    let primaryimageurl: String?
    let titlescount, peoplecount: Int?
    let style: JSONNull?
    let lastupdate: Date?
    let commentary: JSONNull?
    let periodid: Int?
    let technique: String?
    let edition: JSONNull?
    let recordDescription, medium: String?
    let lendingpermissionlevel: Int?
    let title, accessionmethod: String?
    let colors: [Color]?
    let provenance: JSONNull?
    let groupcount: Int?
    let dated, department: String?
    let dateend: Int?
    let people: [Person]?
    let url: String?
    let dateoffirstpageview: JSONNull?
    let century, objectnumber: String?
    let labeltext: JSONNull?
    let datebegin: Int?
    let culture: String?
    let exhibitioncount, imagepermissionlevel, mediacount, objectid: Int?
    let techniqueid: Int?
    let dimensions: String?
    let seeAlso: [SeeAlso]?

    enum CodingKeys: String, CodingKey {
        case copyright, contextualtextcount, creditline, accesslevel, dateoflastpageview, classificationid, division, markscount, publicationcount, totaluniquepageviews, contact, colorcount, rank, details, state, id, verificationleveldescription, period, images, worktypes, imagecount, totalpageviews, accessionyear, standardreferencenumber, signed, classification, relatedcount, verificationlevel, primaryimageurl, titlescount, peoplecount, style, lastupdate, commentary, periodid, technique, edition
        case recordDescription = "description"
        case medium, lendingpermissionlevel, title, accessionmethod, colors, provenance, groupcount, dated, department, dateend, people, url, dateoffirstpageview, century, objectnumber, labeltext, datebegin, culture, exhibitioncount, imagepermissionlevel, mediacount, objectid, techniqueid, dimensions, seeAlso
    }
}

// MARK: - Color
struct Color: Codable {
    let color, spectrum, hue: String?
    let percent: Double?
    let css3: String?
}

// MARK: - Details
struct Details: Codable {
    let coins: Coins?
}

// MARK: - Coins
struct Coins: Codable {
    let reverseinscription: String?
    let dieaxis: JSONNull?
    let metal, obverseinscription, denomination: String?
    let dateonobject: JSONNull?
}

// MARK: - Image
struct Image: Codable {
    let date, copyright: String?
    let imageid, idsid: Int?
    let format: String?
    let imageDescription, technique: JSONNull?
    let renditionnumber: String?
    let displayorder: Int?
    let baseimageurl: String?
    let alttext: JSONNull?
    let width: Int?
    let publiccaption: JSONNull?
    let iiifbaseuri: String?
    let height: Int?

    enum CodingKeys: String, CodingKey {
        case date, copyright, imageid, idsid, format
        case imageDescription = "description"
        case technique, renditionnumber, displayorder, baseimageurl, alttext, width, publiccaption, iiifbaseuri, height
    }
}

// MARK: - Person
struct Person: Codable {
    let role: String?
    let birthplace: JSONNull?
    let gender, displaydate: String?
    let personPrefix: JSONNull?
    let culture, displayname, alphasort, name: String?
    let personid: Int?
    let deathplace: JSONNull?
    let displayorder: Int?

    enum CodingKeys: String, CodingKey {
        case role, birthplace, gender, displaydate
        case personPrefix = "prefix"
        case culture, displayname, alphasort, name, personid, deathplace, displayorder
    }
}

// MARK: - SeeAlso
struct SeeAlso: Codable {
    let id: String?
    let type, format: String?
    let profile: String?
}

// MARK: - Worktype
struct Worktype: Codable {
    let worktypeid, worktype: String?
}

// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    func hash(into hasher: inout Hasher) {
        switch self {
        default:
            break
        }
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
    
}
