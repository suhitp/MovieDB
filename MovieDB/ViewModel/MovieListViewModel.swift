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
    
    private func getMovies(of type: MovieDB) {
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
    
    func sort(by type: MovieDB) {
        pageNum = 0
        getMovies(of: type)
    }
    
}
