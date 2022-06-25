//
//  SearchResult.swift
//  TableGit
//
//  Created by Nguyen Minh Tam on 25/06/2022.
//

import Foundation

struct ResultArray: Codable {
    var resultCount = 0
    var results = [SearchResult]()
}

struct SearchResult: Codable, CustomStringConvertible {
    
    var description: String {
        return "Kind: \(CodingKeys.kind), Name: \(CodingKeys.trackName), Artist Name: \(CodingKeys.artistName)\n"
    }
    var name: String {
        return trackName ?? collectionName ?? ""
    }
    var storeURL: String {
        return trackViewUrl ?? collectionViewUrl ?? ""
    }
    var price: Double {
        return trackPrice ?? collectionPrice ?? itemPrice ?? 0.0
    }
    var genre: String {
        if let genre = itemGenre {
            return genre
        } else if let genres = bookGenre {
            return genres.joined(separator: ", ")
        }
        return ""
    }
    var artist: String {
        return artistName ?? ""
    }
    var artistName: String? = ""
    var trackName: String? = ""
    var kind: String? = ""
    var trackPrice: Double? = 0.0
    var currency = ""
    var imageSmall = ""
    var imageLarge = ""
    var trackViewUrl: String? = ""
    var collectionName: String? = ""
    var collectionViewUrl: String? = ""
    var collectionPrice: Double? = 0.0
    var itemPrice: Double? = 0.0
    var itemGenre: String? = ""
    var bookGenre: [String]? = [""]
    var isFounded = false
    
    var type: String {
        let kind = self.kind ?? "audiobook"
        switch kind {
        case "album": return "Album"
        case "audiobook": return "Audio Book"
        case "book": return "Book"
        case "ebook": return "Software"
        case "feature-movie": return "Movie"
        case "music-video": return "Music video"
        case "podcast": return "Podcast"
        case "software": return "App"
        case "song": return "Song"
        case "tv-episode": return "TV Episode"
        default: break
        }
        return "Unknown"
    }
    
    enum CodingKeys: String, CodingKey {
        case imageSmall = "artworkUrl60"
        case imageLarge = "artworkUrl100"
        case itemGenre = "primaryGenreName"
        case bookGenre = "genres"
        case itemPrice = "price"
        case kind, artistName, currency
        case trackName, trackPrice, trackViewUrl
        case collectionName, collectionViewUrl, collectionPrice
    }
    
}
