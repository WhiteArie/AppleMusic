//
//   SearchResponse.swift
//  AppleMusic
//
//  Created by White on 9/24/22.
//

import UIKit

struct  SearchResponse: Decodable {
    var resultCount: Int
    var results:[Track]
}

struct Track: Decodable {
    var trackName: String
    var artistName: String
    var collectionName: String?  
    var artworkUrl100: String?
    var previewUrl: String? 
}
