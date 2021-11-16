//
//  SearchResult.swift
//  iTunes Search
//
//  Created by Spencer Curtis on 8/5/18.
//  Copyright © 2018 BloomTech. All rights reserved.
//

import Foundation

struct SearchResult: Codable {
 
    let title: String?
    let artist: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case artist = "artistName"
    }
}

struct SearchResults: Codable {
    let results: [SearchResult]
}
