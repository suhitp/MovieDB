//
//  MovieDetailView.swift
//  MovieDB
//
//  Created by Suhit Patil on 17/03/17.
//  Copyright © 2017 Suhit. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailView: UIView {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var detailBackgroundView: UIView!
    @IBOutlet weak var voteCountLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var overviewTextView: UITextView!
    
    func renderDetails(for movie: Movie) {
       
        let isAdult = (movie.adult == true) ? " (A)": ""
        
        titleLabel.text = movie.title.appending(isAdult)
        releaseDate.text = "Releasing on " + movie.release_date.toString()
        
        if let average = movie.vote_average {
            rateLabel.text = "Average Vote: ".appending(String(average))
        }
        
        if let count = movie.vote_count {
            voteCountLabel.text = "Vote Count: ".appending(String(count))
        }
        
        //genresLabel.text = movie.genre_ids.map({"\($0)"}).joined(separator: ",")
        
        overviewTextView.text = movie.overview
        
        if movie.backdrop_path != nil {
            let backdropImageUrl = Constants.backdropImagePath.appending(movie.backdrop_path)
            backgroundImageView.kf.setImage(with: URL(string: backdropImageUrl), options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        }
        
        if movie.poster_path != nil {
            let posterImageUrl = Constants.posterImagePath.appending(movie.poster_path)
            posterImageView.kf.setImage(with: URL(string: posterImageUrl), placeholder: nil, options: [.transition(.fade(0.5))], progressBlock: nil, completionHandler: nil)
        }
        
    }
}
