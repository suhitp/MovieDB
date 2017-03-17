//
//  Movie.swift
//  MovieDB
//
//  Created by Suhit Patil on 16/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import Foundation
import ObjectMapper

struct Movie: Mappable {
    
    var adult: Bool!
    var backdrop_path: String!
    var genre_ids: [Int]!
    var id: Int!
    var original_language: String!
    var original_title: String!
    var overview: String!
    var popularity: Double?
    var poster_path: String!
    var release_date: Date!
    var title: String!
    var video: Bool!
    var vote_average: Double?
    var vote_count: Int?
    
    init?(map: Map) {
        
    }
    
    // Mappable
    mutating func mapping(map: Map) {
        adult <- map["adult"]
        backdrop_path <- map["backdrop_path"]
        genre_ids <- map["genre_ids"]
        id <- map["id"]
        original_language <- map["original_language"]
        original_title <- map["original_title"]
        overview <- map["overview"]
        poster_path <- map["poster_path"]
        
        release_date <- (map["release_date"], CustomDateFormatTransform(formatString: "yyyy-MM-dd"))
        title <- map["title"]
        video <- map["video"]
        popularity <- map["popularity"]
        vote_average <- map["vote_average"]
        vote_count <- map["vote_count"]
    }
}
