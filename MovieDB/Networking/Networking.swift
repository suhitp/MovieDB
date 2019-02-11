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
