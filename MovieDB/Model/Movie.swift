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
    var poster_path: String!
    var release_date: String!
    var title: String!
    var video: Bool!
    var vote_average: String!
    var vote_count: Int!
    
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
        release_date <- map["release_date"]
        title <- map["title"]
        video <- map["video"]
        vote_average <- map["vote_average"]
        vote_count <- map["vote_count"]
    }
    
    
    /*
 
 adult = 0;
 "backdrop_path" = "/5pAGnkFYSsFJ99ZxDIYnhQbQFXs.jpg";
 "genre_ids" =             (
 28,
 18,
 878
 );
 id = 263115;
 "original_language" = en;
 "original_title" = Logan;
 overview = "In the near future, a weary Logan cares for an ailing Professor X in a hide out on the Mexican border. But Logan's attempts to hide from the world and his legacy are up-ended when a young mutant arrives, being pursued by dark forces.";
 popularity = "171.249545";
 "poster_path" = "/45Y1G5FEgttPAwjTYic6czC9xCn.jpg";
 "release_date" = "2017-02-28";
 title = Logan;
 video = 0;
 "vote_average" = "7.7";
 "vote_count" = 1295;
*/
 
}
