//
//  MovieDB.swift
//  MovieDB
//
//  Created by Suhit Patil on 11/02/2019.
//  Copyright © 2019 Suhit. All rights reserved.
//

import Moya


public enum MovieDB {
    case releaseDate
    case popular
    case top
}

extension MovieDB: TargetType {
    
    public var baseURL: URL { return URL(string: "https://api.themoviedb.org/3")! }
    public var path: String {
        switch self {
        case .releaseDate,.popular, .top:
            return "/discover/movie"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var parameters: [String: Any]? {
        switch self {
        case .releaseDate:
            return ["page": pageNum,
                    "api_key": apiKey,
                    "primary_release_date.gte" : "2017-01-01",
                    "primary_release_date.lte" : "2017-12-31", "sort_by": "primary_release_date.desc", ]
        case .popular:
            return ["page": pageNum,
                    "api_key": apiKey,
                    "primary_release_date.gte" : "2017-01-01",
                    "primary_release_date.lte" : "2017-12-31", "sort_by": "popularity.desc"]
        case .top:
            return ["page": pageNum,
                    "api_key": apiKey,
                    "primary_release_date.gte" : "2017-01-01",
                    "primary_release_date.lte" : "2017-12-31", "sort_by": "vote_average.desc"]
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    public var task: Task {
        return .requestPlain
    }
    
    public var validate: Bool {
        switch self {
        case .releaseDate, .popular, .top:
            return true
        }
    }
    
    
    public var sampleData: Data {
        switch self {
        case .popular:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .top:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        case .releaseDate:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}
