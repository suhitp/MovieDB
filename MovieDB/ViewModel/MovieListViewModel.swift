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
    }
    
    func getMovies(of type: MovieDB) {
        self.provider.request(type) { (result) in
            do {
                let response = try result.dematerialize()
                let value = try response.mapJSON() as! [String: Any]
                print(value)
                if let movies = Mapper<Movie>().mapArray(JSONArray: (value["results"] as! [[String: Any]])) {
                    self.delegate?.didReceiveDataWith(movies)
                }
            } catch {
                let printableError = error as? CustomStringConvertible
                let errorMessage = printableError?.description ?? "Unable to fetch from GitHub"
                self.delegate?.didReceiveDataWith(error)
            }
        }
    }
    
}
