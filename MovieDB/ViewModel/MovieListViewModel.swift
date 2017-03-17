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
        getMovies(of: .releaseDate)
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
                self.delegate?.didReceiveDataWith(error)
            }
        }
    }
    
    func sort(_ movies: [Movie], by type: MovieDB) -> [Movie] {
        switch type {
        case .releaseDate:
            return movies.sorted(by: {
                $0.release_date > $1.release_date
            })
            
        case .popular:
            return movies.sorted(by: {
                $0.popularity > $1.popularity
            })
            
        case .top:
            return movies.sorted(by: {
                return $0.vote_average > $1.vote_average
            })
        }
    }
    
}
