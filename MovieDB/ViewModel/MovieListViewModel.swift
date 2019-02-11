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
    public var total_pages: Int = 0
    
    enum LoadingState {
        case none
        case loading
    }
    
    public var loadingState: LoadingState
    
    init(provider: MoyaProvider<MovieDB>, loadingState: LoadingState = .none) {
        self.provider = provider
        self.loadingState = loadingState
        getMovies(of: .popular)
    }
    
    /*!
     * @discussion get movies from MovieDB API
     * @param movie sort option type
     * @return array of movies or error
     */
    private func getMovies(of type: MovieDB) {
        self.provider.request(type) { (result) in
            do {
                let response = try result.dematerialize()
                let value = try response.mapJSON() as! [String: Any]
                
                print(value)
                
                if let total = value["total_pages"] as? Int {
                    self.total_pages = total
                }
                
//                if let movies = Mapper<Movie>().mapArray(JSONArray: value["results"] as! [[String : Any]]) {
//                    self.delegate?.didReceiveDataWith(movies)
//                }
                
            } catch {
                self.delegate?.didReceiveDataWith(error)
            }
        }
    }
    
    
    /*!
     * @discussion Load more movies of given type
     * @param movie sort option type
     * @return
     */
    func loadMore(_ type: MovieDB) {
        
        guard pageNum < self.total_pages else {
            return
        }
        
        pageNum += 1
        getMovies(of: type)
    }
    
    
    /*!
     * @discussion Sort movies by type
     * @param movie sort option type
     * @return
     */
    func sort(by type: MovieDB) {
        pageNum = 1
        getMovies(of: type)
    }
    
}
