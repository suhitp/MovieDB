//
//  MovieDetailViewModel.swift
//  MovieDB
//
//  Created by Suhit Patil on 17/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit

class MovieDetailViewModel: NSObject {

    var movie: Movie!
    
    init(movie: Movie) {
        self.movie = movie
    }
    
}
