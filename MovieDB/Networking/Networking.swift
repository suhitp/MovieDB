//
//  Networking.swift
//  MovieDB
//
//  Created by Suhit Patil on 16/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import Foundation
import Moya

let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzOTYzZTZlOTdlN2IwYmYxNTQ3YmM3ZDNlMzE3YTdmMSIsInN1YiI6IjU4YmVhZTdhOTI1MTQxNjA3NzA2MjhiZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.U2CfQ-INBH_fEhfhK1q58SiFVcgLNDQCy-ttvqFHqCA"
let apiKey = "3963e6e97e7b0bf1547bc7d3e317a7f1"

var pageNum = 1

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

let MovieDBProvider = MoyaProvider<MovieDB>()

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

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
        return .request
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
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

//MARK: - Response Handlers

extension Moya.Response {
    
    func maptoArray() throws -> Array<Any> {
        let any = try self.mapJSON()
        guard let array = any as? Array<Any> else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
