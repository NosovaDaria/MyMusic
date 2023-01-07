//
//  SearchResponse.swift
//  MyMusic
//
//  Created by Дарья Носова on 07.12.2022.
//

import Foundation

struct SearchResponse: Decodable {
    var resultCount: Int
    var results: [Track]
}

struct Track: Decodable {
    var artistName: String
    var collectionName: String
    var trackName: String
    var artworkUrl100: String?
    var previewUrl: String?
}
