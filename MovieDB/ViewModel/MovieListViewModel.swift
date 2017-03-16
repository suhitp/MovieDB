//
//  MovieListViewModel.swift
//  MovieDB
//
//  Created by Suhit Patil on 16/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import ObjectMapper

final class MovieListViewModel {
    
    // Private
    private let provider: MoyaProvider<MovieDB>
    weak var delegate: MovieDataProtocol?
    
    init(provider: MoyaProvider<MovieDB>) {
        self.provider = provider
        getMovies(of: .popular)
    }
    
    func getMovies(of type: MovieDB) {
        self.provider.request(type) { (result) in
            do {
                let response = try result.dematerialize()
                let value = try response.mapJSON() as! [String: Any]
                let movieArray = Mapper<Movie>().mapArray(JSONArray: value["results"] as! [[String: Any]])
            } catch {
                let printableError = error as? CustomStringConvertible
                let errorMessage = printableError?.description ?? "Unable to fetch from GitHub"
                print(errorMessage)
            }
        }
    }
    
}
